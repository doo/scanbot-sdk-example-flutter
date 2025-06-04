import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';
import 'package:scanbot_sdk_example_flutter/ui/preview/check_preview.dart';
import 'package:scanbot_sdk_example_flutter/ui/preview/credit_card_preview.dart';

import '../ui/menu_item_widget.dart';
import '../ui/preview/ehic_preview.dart';
import '../ui/preview/extracted_document_data_preview.dart';
import '../ui/preview/medical_certificate_preview.dart';
import '../ui/preview/mrz_document_preview.dart';
import '../ui/preview/text_pattern_preview.dart';
import '../ui/preview/vin_preview.dart';
import '../utility/utils.dart';


class DataCaptureUseCases extends StatelessWidget {
  const DataCaptureUseCases({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleItemWidget(title: 'Recognizers'),
        MenuItemWidget(title: "Recognize MRZ from Still Image", onTap: () => _recognizeMrzOnImage(context)),
        MenuItemWidget(title: "Recognize Medical Certificate from Still Image", onTap: () => _recognizeMedicalCertificateOnImage(context)),
        MenuItemWidget(title: "Recognize EHIC from Still Image", onTap: () => _recognizeHealthInsuranceCardOnImage(context)),
        MenuItemWidget(title: "Extract Document Data from Still Image", onTap: () => _extractDocumentDataFromImage(context)),
        MenuItemWidget(title: "Recognize Check from Still Image", onTap: () => _recognizeCheckOnImage(context)),
        MenuItemWidget(title: "Recognize Credit Card from Still Image", onTap: () => _recognizeCreditCardOnImage(context)),
        const TitleItemWidget(title: 'Data Detectors'),
        MenuItemWidget(title: "Extract Document Data", onTap: () => _startDocumentDataExtractorScanner(context)),
        MenuItemWidget(title: "Scan MRZ (Machine Readable Zone)", onTap: () => startMRZScanner(context)),
        MenuItemWidget(title: "Scan EHIC (European Health Insurance Card)", onTap: () => startEhicScanner(context)),
        MenuItemWidget(title: "Scan VIN", onTap: () => startVINScanner(context)),
        MenuItemWidget(title: "Scan Check", onTap: () => startCheckScanner(context)),
        MenuItemWidget(title: "Scan Text Data", onTap: () => startTextDataScanner(context)),
        MenuItemWidget(title: "Scan Medical Certificate", onTap: () => startMedicalCertificateScanner(context)),
        MenuItemWidget(title: "Scan Credit Scanner", onTap: () => startCreditCardScanner(context)),
      ],
    );
  }

  Future<void> startRecognizer<T>({
    required BuildContext context,
    required Future<T> Function(String path) scannerFunction,
    required Future<void> Function(BuildContext, T result) handleResult,
  }) async {
    if (!await checkLicenseStatus(context)) return;

    try {
      final response = await selectImageFromLibrary();
      if (response != null && response.path.isNotEmpty) {
        final result = await scannerFunction(response.path);
        await handleResult(context, result);
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> handleRecognizedResult({
    required BuildContext context,
    required bool isOperationSucceed,
    required String dataTitle,
    required String resultTextToShow,
  }) async {
    if (isOperationSucceed) {
      await showAlertDialog(context, resultTextToShow, title: "$dataTitle recognized");
    } else {
      await showAlertDialog(context, "", title: '$dataTitle not recognized');
    }
  }

  Future<void> startDetector<T>({
    required BuildContext context,
    required Future<T> Function() scannerFunction,
    required Future<void> Function(BuildContext, T result) handleResult,
  }) async {
    if (!await checkLicenseStatus(context)) return;

    try {
      final result = await scannerFunction();
      await handleResult(context, result);
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> _recognizeMrzOnImage(BuildContext context) async {
      var configuration = MrzScannerConfiguration();
      configuration.frameAccumulationConfiguration = AccumulatedResultsVerifierConfiguration(minimumNumberOfRequiredFramesWithEqualScanningResult: 1);
      configuration.incompleteResultHandling = MrzIncompleteResultHandling.REJECT;
      // Configure other parameters as needed.

      await startRecognizer<MrzScannerResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdk.recognizeOperations.recognizeMrzOnImage(path, configuration),
        handleResult: (context, result) async {
          if (result.success) {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MrzDocumentResultPreview(scannerResult: result)),
            );
          }
        },
      );
  }

  Future<void> _recognizeMedicalCertificateOnImage(BuildContext context) async {
    var configuration = MedicalCertificateScanningParameters();
    configuration.recognizePatientInfoBox = true;
    // Configure other parameters as needed.

    await startRecognizer<MedicalCertificateScanningResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdk.recognizeOperations.recognizeMedicalCertificateOnImage(path, configuration),
        handleResult: (context, result) async {
            if (result.scanningSuccessful) {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MedicalCertificatePreviewWidget(result)),
              );
            }
          },
    );
  }

  Future<void> _recognizeHealthInsuranceCardOnImage(BuildContext context) async {
    var configuration = EuropeanHealthInsuranceCardRecognizerConfiguration();
    configuration.maxExpirationYear = 2100;
    // Configure other parameters as needed.

    await startRecognizer<EuropeanHealthInsuranceCardRecognitionResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdk.recognizeOperations.recognizeHealthInsuranceCardOnImage(path, configuration),
        handleResult: (context, result) async {
          if (result.status == EuropeanHealthInsuranceCardRecognitionResultRecognitionStatus.SUCCESS) {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EuropeanHealthInsuranceCardResultPreview(result)),
            );
          }
        },
      );
  }

  Future<void> _extractDocumentDataFromImage(BuildContext context) async {
    var commonConfig = DocumentDataExtractorCommonConfiguration(
        acceptedDocumentTypes: [
          MRZ.DOCUMENT_TYPE,
          DeIdCardFront.DOCUMENT_TYPE,
          DeIdCardBack.DOCUMENT_TYPE,
          DePassport.DOCUMENT_TYPE,
          DeDriverLicenseFront.DOCUMENT_TYPE,
          DeDriverLicenseBack.DOCUMENT_TYPE,
          DeResidencePermitFront.DOCUMENT_TYPE,
          DeResidencePermitBack.DOCUMENT_TYPE,
          EuropeanHealthInsuranceCard.DOCUMENT_TYPE,
          DeHealthInsuranceCardFront.DOCUMENT_TYPE,
        ]
      );

    var configuration = DocumentDataExtractorConfiguration(
      configurations: [commonConfig],
    );
    // Configure other parameters as needed.

    await startRecognizer<DocumentDataExtractionResult>(
        context: context,
        scannerFunction: (path) => _runDocumentDataRecognizer(configuration, path),
        handleResult: (context, result) async {
          if (result.document != null) {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ExtractedDocumentDataPreview([result])),
        );
      }
    });
  }

  Future<DocumentDataExtractionResult> _runDocumentDataRecognizer(DocumentDataExtractorConfiguration configuration, String path) async {
    return await autorelease(() async {
      return await ScanbotSdk.recognizeOperations.extractDocumentDataFromImage(path, configuration);
    });
  }

  Future<void> _recognizeCheckOnImage(BuildContext context) async {
    var configuration = CheckScannerConfiguration();
    configuration.documentDetectionMode = CheckDocumentDetectionMode.DETECT_AND_CROP_DOCUMENT;
    // Configure other parameters as needed.

    await startRecognizer<CheckScanningResult>(
        context: context,
        scannerFunction: (path) => _runCheckRecognize(configuration, path),
        handleResult: (context, result) async {
          if (result.status == CheckMagneticInkStripScanningStatus.SUCCESS) {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CheckDocumentResultPreview(result)),
            );
          }
        },
    );
  }

  Future<CheckScanningResult> _runCheckRecognize(CheckScannerConfiguration configuration, String path) async {
    return await autorelease(() async {
      return await ScanbotSdk.recognizeOperations.recognizeCheckOnImage(path, configuration);
    });
  }

  Future<void> _recognizeCreditCardOnImage(BuildContext context) async {
    var configuration = CreditCardScannerConfiguration();
    configuration.scanningMode = CreditCardScanningMode.SINGLE_SHOT;
    // Configure other parameters as needed.

    await startRecognizer<CreditCardScanningResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdk.recognizeOperations.recognizeCreditCardOnImage(path, configuration),
        handleResult: (context, result) async {
          if (result.scanningStatus != CreditCardScanningStatus.ERROR_NOTHING_FOUND) {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreditCardResultPreview(scanningResult: result)),
            );
          }
        }
    );
  }

  Future<void> startVINScanner(BuildContext context) async {
    var configuration = VinScannerConfiguration();
    configuration.topBarBackgroundColor = ScanbotRedColor;
    configuration.topBarButtonsActiveColor = Colors.white;
    // Configure other parameters as needed.

    await startDetector<ResultWrapper<VinScannerResult>>(
        context: context,
        scannerFunction: () => ScanbotSdkUi.startVinScanner(configuration),
        handleResult: (context, result) async {
          if (result.status == OperationStatus.OK) {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => VinScannerResultPreview(result.data!)),
            );
          }
        },
    );
  }

  Future<void> _startDocumentDataExtractorScanner(BuildContext context) async {
    var configuration = DocumentDataExtractorScreenConfiguration();
    configuration.finderLineColor = ScanbotRedColor;
    configuration.topBarBackgroundColor = ScanbotRedColor;
    configuration.topBarButtonsActiveColor = Colors.white;
    // Configure other parameters as needed.

    await startDetector<ResultWrapper<List<DocumentDataExtractionResult>>>(
      context: context,
      scannerFunction: () => _runDocumentDataExtractor(configuration),
      handleResult: (context, result) async {
        if (result.status == OperationStatus.OK) {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ExtractedDocumentDataPreview(result.data!)),
          );
        }
      },
    );
  }

  Future<ResultWrapper<List<DocumentDataExtractionResult>>> _runDocumentDataExtractor(DocumentDataExtractorScreenConfiguration configuration) async {
    return await autorelease(() async {
      return await ScanbotSdkUi.startDocumentDataExtractor(configuration);
    });
  }

  Future<void> startCheckScanner(BuildContext context) async {
    var configuration = CheckScannerScreenConfiguration();
    configuration.topBarBackgroundColor = ScanbotRedColor;
    configuration.topBarButtonsActiveColor = Colors.white;
    // Configure other parameters as needed.

    await startDetector<ResultWrapper<CheckScanningResult>>(
        context: context,
        scannerFunction: () => _runCheckScanner(configuration),
        handleResult: (context, result) async {
          if (result.status == OperationStatus.OK) {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CheckDocumentResultPreview(result.data!)),
            );
          }
        },
    );
  }

  Future<ResultWrapper<CheckScanningResult>> _runCheckScanner(CheckScannerScreenConfiguration configuration) async {
    return await autorelease(() async {
      return await ScanbotSdkUi.startCheckScanner(configuration);
    });
  }

  Future<void> startTextDataScanner(BuildContext context) async {
    var configuration = TextPatternScannerScreenConfiguration();
    // Configure other parameters as needed.

    await startDetector<ResultWrapper<TextPatternScannerUiResult>>(
        context: context,
        scannerFunction: () => ScanbotSdkUiV2.startTextPatternScanner(configuration),
        handleResult: (context, result) async {
          if (result.status == OperationStatus.OK) {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => TextPatternScannerUiResultPreview(result.data!)),
            );
          }
        },
    );
  }

  Future<void> startMedicalCertificateScanner(BuildContext context) async {
    var configuration = MedicalCertificateScannerConfiguration();
    configuration.returnCroppedDocumentImage = false;
    configuration.topBarBackgroundColor = ScanbotRedColor;
    configuration.topBarButtonsActiveColor = Colors.white;
    // Configure other parameters as needed.

    await startDetector<ResultWrapper<MedicalCertificateScanningResult>>(
        context: context,
        scannerFunction: () => ScanbotSdkUi.startMedicalCertificateScanner(configuration),
        handleResult: (context, result) async {
          if (result.status == OperationStatus.OK) {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MedicalCertificatePreviewWidget(result.data!)),
            );
          }
        },
    );
  }

  Future<void> startCreditCardScanner(BuildContext context) async {
    var configuration = CreditCardScannerScreenConfiguration();
    // Configure other parameters as needed.

    await startDetector<ResultWrapper<CreditCardScannerUiResult>>(
        context: context,
        scannerFunction: () => ScanbotSdkUiV2.startCreditCardScanner(configuration),
        handleResult: (context, result) async {
          if (result.status == OperationStatus.OK) {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreditCardResultPreview(uiResult: result.data!)),
            );
          }
        },
    );
  }

  Future<void> startEhicScanner(BuildContext context) async {
    var configuration = HealthInsuranceCardScannerConfiguration();
    // Configure other parameters as needed.

    await startDetector<ResultWrapper<EuropeanHealthInsuranceCardRecognitionResult>>(
      context: context,
      scannerFunction: () => ScanbotSdkUi.startEhicScanner(configuration),
      handleResult: (context, result) async {
        if (result.status == OperationStatus.OK) {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EuropeanHealthInsuranceCardResultPreview(result.data!)),
          );
        }
      },
    );
  }

  Future<void> startMRZScanner(BuildContext context) async {
    var configuration = MrzScannerScreenConfiguration();
    // Configure other parameters as needed.

    await startDetector<ResultWrapper<MrzScannerUiResult>>(
      context: context,
      scannerFunction: () => ScanbotSdkUiV2.startMrzScanner(configuration),
      handleResult: (context, result) async {
        if (result.status == OperationStatus.OK) {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MrzDocumentResultPreview(uiResult: result.data!)),
          );
        }
      },
    );
  }
}
