import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk_example_flutter/ui/preview/check_preview.dart';
import 'package:scanbot_sdk_example_flutter/ui/preview/credit_card_preview.dart';

import '../ui/menu_item_widget.dart';
import '../ui/preview/extracted_document_data_preview.dart';
import '../ui/preview/mrz_document_preview.dart';
import '../ui/preview/text_pattern_preview.dart';
import '../ui/preview/vin_preview.dart';
import '../ui/progress_dialog.dart';
import '../utility/utils.dart';

class DataCaptureUseCases extends StatelessWidget {
  const DataCaptureUseCases({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleItemWidget(title: 'Recognizers'),
        MenuItemWidget(
            title: "Recognize MRZ from Still Image",
            onTap: () => _recognizeMrzOnImage(context)),
        MenuItemWidget(
            title: "Extract Document Data from Still Image",
            onTap: () => _extractDocumentDataFromImage(context)),
        MenuItemWidget(
            title: "Recognize Check from Still Image",
            onTap: () => _recognizeCheckOnImage(context)),
        MenuItemWidget(
            title: "Recognize Credit Card from Still Image",
            onTap: () => _recognizeCreditCardOnImage(context)),
        const TitleItemWidget(title: 'Data Detectors'),
        MenuItemWidget(
            title: "Extract Document Data",
            onTap: () => _startDocumentDataExtractorScanner(context)),
        MenuItemWidget(
            title: "Scan MRZ (Machine Readable Zone)",
            onTap: () => startMRZScanner(context)),
        MenuItemWidget(
            title: "Scan VIN", onTap: () => startVINScanner(context)),
        MenuItemWidget(
            title: "Scan Check", onTap: () => startCheckScanner(context)),
        MenuItemWidget(
            title: "Scan Text Data",
            onTap: () => startTextDataScanner(context)),
        MenuItemWidget(
            title: "Scan Credit Scanner",
            onTap: () => startCreditCardScanner(context)),
      ],
    );
  }

  Future<void> startRecognizer<T>({
    required BuildContext context,
    required Future<Result<T>> Function(String path) scannerFunction,
    required Future<void> Function(BuildContext, T result) handleResult,
  }) async {
    if (!await checkLicenseStatus(context)) return;

    final dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait...');

    final response = await selectImageFromLibrary();

    if (response != null && response.path.isNotEmpty) {
      dialog.show();

      final result = await scannerFunction(response.path);
      if (result is Ok<T>) {
        await handleResult(context, result.value);
      }
      await dialog.hide();
    }
  }

  Future<void> startDetector<T>({
    required BuildContext context,
    required Future<T> Function() scannerFunction,
    required Future<void> Function(BuildContext, T result) handleResult,
  }) async {
    if (!await checkLicenseStatus(context)) return;

    final result = await scannerFunction();
    await handleResult(context, result);
  }

  Future<void> _recognizeMrzOnImage(BuildContext context) async {
    var configuration = MrzScannerConfiguration();
    configuration.incompleteResultHandling = MrzIncompleteResultHandling.REJECT;
    // Configure other parameters as needed.

    await startRecognizer<MrzScannerResult>(
      context: context,
      scannerFunction: (path) =>
          ScanbotSdk.mrz.scanFromImageFileUri(path, configuration),
      handleResult: (context, result) async {
        if (result.success) {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    MrzDocumentResultPreview(scannerResult: result)),
          );
        } else {
          await showAlertDialog(context, "Operation Status: ${result.success}");
        }
      },
    );
  }

  Future<void> _extractDocumentDataFromImage(BuildContext context) async {
    var commonConfig =
        DocumentDataExtractorCommonConfiguration(acceptedDocumentTypes: [
      DeIdCardFront.DOCUMENT_TYPE,
      DeIdCardBack.DOCUMENT_TYPE,
      DeHealthInsuranceCardFront.DOCUMENT_TYPE,
      DePassport.DOCUMENT_TYPE,
      DeResidencePermitFront.DOCUMENT_TYPE,
      DeResidencePermitBack.DOCUMENT_TYPE,
      EuropeanDriverLicenseFront.DOCUMENT_TYPE,
      EuropeanDriverLicenseBack.DOCUMENT_TYPE,
      EuropeanHealthInsuranceCard.DOCUMENT_TYPE,
    ]);

    var configuration = DocumentDataExtractorConfiguration(
      configurations: [commonConfig],
    );
    // Configure other parameters as needed.

    await startRecognizer<DocumentDataExtractionResult>(
        context: context,
        scannerFunction: (path) =>
            _runDocumentDataRecognizer(configuration, path),
        handleResult: (context, result) async {
          if (result.document != null) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      ExtractedDocumentDataPreview(scanningResult: result)),
            );
          } else {
            await showAlertDialog(
                context, "Operation Status: ${result.status.name}");
          }
        });
  }

  Future<Result<DocumentDataExtractionResult>> _runDocumentDataRecognizer(
      DocumentDataExtractorConfiguration configuration, String path) async {
    /// You must use autorelease for result object
    /// otherwise you'll get exception "AutoReleasable objects must be created within autorelease"

    return await autorelease(() async {
      var extractedData = await ScanbotSdk.documentDataExtractor
          .extractFromImageFileUri(path, configuration);

      /// if you want to use image later, call encodeImages() to save in buffer
      //  extractedData.encodeImages();
      return extractedData;
    });
  }

  Future<void> _recognizeCheckOnImage(BuildContext context) async {
    var configuration = CheckScannerConfiguration();
    configuration.documentDetectionMode =
        CheckDocumentDetectionMode.DETECT_AND_CROP_DOCUMENT;
    // Configure other parameters as needed.

    await startRecognizer<CheckScanningResult>(
      context: context,
      scannerFunction: (path) => _runCheckRecognize(configuration, path),
      handleResult: (context, result) async {
        if (result.status ==
            CheckMagneticInkStripScanningStatus.ERROR_NOTHING_FOUND) {
          await showAlertDialog(
              context, "Operation Status: ${result.status.name}");
        } else {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    CheckDocumentResultPreview(scanningResult: result)),
          );
        }
      },
    );
  }

  Future<Result<CheckScanningResult>> _runCheckRecognize(
      CheckScannerConfiguration configuration, String path) async {
    /// You must use autorelease for result object
    /// otherwise you'll get exception "AutoReleasable objects must be created within autorelease"

    return await autorelease(() async {
      var checkScanningResult =
          await ScanbotSdk.check.scanFromImageFileUri(path, configuration);

      /// if you want to use image later, call encodeImages() to save in buffer
      //  checkScanningResult.encodeImages();
      return checkScanningResult;
    });
  }

  Future<void> _recognizeCreditCardOnImage(BuildContext context) async {
    var configuration = CreditCardScannerConfiguration();
    configuration.requireExpiryDate = true;
    // Configure other parameters as needed.

    await startRecognizer<CreditCardScanningResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdk.creditCard.scanFromImageFileUri(path, configuration),
        handleResult: (context, result) async {
          if (result.scanningStatus !=
              CreditCardScanningStatus.ERROR_NOTHING_FOUND) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      CreditCardResultPreview(scanningResult: result)),
            );
          } else {
            await showAlertDialog(
                context, "Operation Status: ${result.scanningStatus.name}");
          }
        });
  }

  Future<void> startVINScanner(BuildContext context) async {
    var configuration = VinScannerScreenConfiguration();
    configuration.introScreen.explanation.text =
        'Quickly and securely scan the VIN by holding your device over the vehicle identification number or vehicle identification barcode' +
            '\\nThe scanner will guide you to the optimal scanning position.' +
            'Once the scan is complete, your VIN details will automatically be extracted and processed.';
    // Configure the done button. E.g., the text or the background color.
    configuration.introScreen.doneButton.text = 'Start Scanning';
    configuration.introScreen.doneButton.background.fillColor =
        ScanbotColor('#C8193C');
    // Configure other parameters as needed.

    await startDetector<Result<VinScannerUiResult>>(
      context: context,
      scannerFunction: () => ScanbotSdk.vin.startScanner(configuration),
      handleResult: (context, result) async {
        if (result is Ok<VinScannerUiResult>) {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    VinScannerResultPreview(uiResult: result.value)),
          );
        } else if (result is Error<VinScannerUiResult>) {
          await showAlertDialog(context, "Error: ${result.error.message}");
        }
      },
    );
  }

  Future<void> _startDocumentDataExtractorScanner(BuildContext context) async {
    var configuration = DocumentDataExtractorScreenConfiguration();
    configuration.viewFinder.overlayColor = ScanbotColor('#C8193C');
    // Configure other parameters as needed.

    await startDetector<Result<DocumentDataExtractorUiResult>>(
      context: context,
      scannerFunction: () => _runDocumentDataExtractor(configuration),
      handleResult: (context, result) async {
        if (result is Ok<DocumentDataExtractorUiResult>) {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    ExtractedDocumentDataPreview(uiResult: result.value)),
          );
        } else if (result is Error<DocumentDataExtractorUiResult>) {
          await showAlertDialog(context, "Error: ${result.error.message}");
        }
      },
    );
  }

  Future<Result<DocumentDataExtractorUiResult>> _runDocumentDataExtractor(
      DocumentDataExtractorScreenConfiguration configuration) async {
    /// You must use autorelease for result object
    /// otherwise you'll get exception "AutoReleasable objects must be created within autorelease"

    return await autorelease(() async {
      var extractedData = await ScanbotSdk.documentDataExtractor
          .startExtractorScreen(configuration);

      /// if you want to use image later, call encodeImages() to save in buffer
      //  extractedData.data?.forEach((item) {
      //    item.encodeImages();
      //  });
      return extractedData;
    });
  }

  Future<void> startCheckScanner(BuildContext context) async {
    var configuration = CheckScannerScreenConfiguration();
    // Modify behaviors
    configuration.exampleOverlayVisible = true;
    // Set colors
    configuration.palette.sbColorPrimary = ScanbotColor('#C8193C');
    configuration.palette.sbColorOnPrimary = ScanbotColor('#FFFFFF');
    // Configure other parameters as needed.

    await startDetector<Result<CheckScannerUiResult>>(
      context: context,
      scannerFunction: () => _runCheckScanner(configuration),
      handleResult: (context, result) async {
        if (result is Ok<CheckScannerUiResult>) {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    CheckDocumentResultPreview(uiResult: result.value)),
          );
        } else if (result is Error<CheckScannerUiResult>) {
          await showAlertDialog(context, "Error: ${result.error.message}");
        }
      },
    );
  }

  Future<Result<CheckScannerUiResult>> _runCheckScanner(
      CheckScannerScreenConfiguration configuration) async {
    /// You must use autorelease for result object
    /// otherwise you'll get exception "AutoReleasable objects must be created within autorelease"

    return await autorelease(() async {
      var checkScanningResult =
          await ScanbotSdk.check.startScanner(configuration);

      /// if you want to use image later, call encodeImages() to save in buffer
      //  checkScanningResult.data?.encodeImages();
      return checkScanningResult;
    });
  }

  Future<void> startTextDataScanner(BuildContext context) async {
    var configuration = TextPatternScannerScreenConfiguration();
    // Show the top user guidance
    configuration.topUserGuidance.visible = true;
    // Customize the top user guidance
    configuration.topUserGuidance.title.text = 'Customized title';
    // Configure parameters as needed.

    await startDetector<Result<TextPatternScannerUiResult>>(
      context: context,
      scannerFunction: () => ScanbotSdk.textPattern.startScanner(configuration),
      handleResult: (context, result) async {
        if (result is Ok<TextPatternScannerUiResult>) {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    TextPatternScannerUiResultPreview(result.value)),
          );
        } else if (result is Error<TextPatternScannerUiResult>) {
          await showAlertDialog(context, "Error: ${result.error.message}");
        }
      },
    );
  }

  Future<void> startCreditCardScanner(BuildContext context) async {
    var configuration = CreditCardScannerScreenConfiguration();
    // Configure the top bar mode
    configuration.topBar.mode = TopBarMode.GRADIENT;
    // Configure the top bar status bar mode
    configuration.topBar.statusBarMode = StatusBarMode.LIGHT;
    // Configure the top bar background color
    configuration.topBar.cancelButton.text = 'Cancel';
    // Configure parameters as needed.

    await startDetector<Result<CreditCardScannerUiResult>>(
      context: context,
      scannerFunction: () => ScanbotSdk.creditCard.startScanner(configuration),
      handleResult: (context, result) async {
        if (result is Ok<CreditCardScannerUiResult>) {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    CreditCardResultPreview(uiResult: result.value)),
          );
        } else if (result is Error<CreditCardScannerUiResult>) {
          await showAlertDialog(context, "Error: ${result.error.message}");
        }
      },
    );
  }

  Future<void> startMRZScanner(BuildContext context) async {
    var configuration = MrzScannerScreenConfiguration();
    // Show the introduction screen automatically when the screen appears.
    configuration.introScreen.showAutomatically = true;
    // Configure parameters as needed.

    await startDetector<Result<MrzScannerUiResult>>(
      context: context,
      scannerFunction: () => ScanbotSdk.mrz.startScanner(configuration),
      handleResult: (context, result) async {
        if (result is Ok<MrzScannerUiResult>) {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    MrzDocumentResultPreview(uiResult: result.value)),
          );
        } else if (result is Error<MrzScannerUiResult>) {
          await showAlertDialog(context, "Error: ${result.error.message}");
        }
      },
    );
  }
}
