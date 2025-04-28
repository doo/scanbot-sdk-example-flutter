import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

import '../ui/menu_item_widget.dart';
import '../ui/preview/generic_document_preview.dart';
import '../ui/preview/mrz_document_preview.dart';
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
        MenuItemWidget(title: "Recognize Generic Document from Still Image", onTap: () => _recognizeGenericDocumentOnImage(context)),
        MenuItemWidget(title: "Recognize Check from Still Image", onTap: () => _recognizeCheckOnImage(context)),
        MenuItemWidget(title: "Recognize Credit Card from Still Image", onTap: () => _recognizeCreditCardOnImage(context)),
        const TitleItemWidget(title: 'Data Detectors'),
        MenuItemWidget(title: "Scan Generic Document", onTap: () => _startDocumentDataExtractorScanner(context)),
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
    required void Function(T result) handleResult,
  }) async {
    if (!await checkLicenseStatus(context)) return;

    try {
      final response = await selectImageFromLibrary();
      if (response != null && response.path.isNotEmpty) {
        final result = await scannerFunction(response.path);
        handleResult(result);
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
      await showAlertDialog(context, '$dataTitle not recognized');
    }
  }

  Future<void> startDetector<T>({
    required BuildContext context,
    required Future<T> Function() scannerFunction,
    required void Function(T result) handleResult,
  }) async {
    if (!await checkLicenseStatus(context)) return;

    try {
      final result = await scannerFunction();
      handleResult(result);
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> _recognizeMrzOnImage(BuildContext context) async {
      await startRecognizer<MrzScannerResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdk.recognizeOperations.recognizeMrzOnImage(path),
        handleResult: (result) => handleRecognizedResult(
          context: context,
          isOperationSucceed: result.success,
          dataTitle: "Mrz",
          resultTextToShow: "Success",
      ));
  }

  Future<void> _recognizeMedicalCertificateOnImage(BuildContext context) async {
    await startRecognizer<MedicalCertificateScanningResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdk.recognizeOperations.recognizeMedicalCertificateOnImage(path),
        handleResult: (result) => handleRecognizedResult(
            context: context,
            isOperationSucceed: result.scanningSuccessful,
            dataTitle: "Medical Certificate",
            resultTextToShow: "Success",
        ));
  }

  Future<void> _recognizeHealthInsuranceCardOnImage(BuildContext context) async {
    await startRecognizer<EuropeanHealthInsuranceCardRecognitionResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdk.recognizeOperations.recognizeHealthInsuranceCardOnImage(
                path),
        handleResult: (result) =>
            handleRecognizedResult(
                context: context,
                isOperationSucceed: result.status == EuropeanHealthInsuranceCardRecognitionResultRecognitionStatus.SUCCESS,
                dataTitle: "HealthInsuranceCard",
                resultTextToShow: "Success",
            ));
  }

  Future<void> _recognizeGenericDocumentOnImage(BuildContext context) async {
    await startRecognizer<DocumentDataExtractionResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdk.recognizeOperations.recognizeGenericDocumentOnImage(
                path),
        handleResult: (result) =>
            handleRecognizedResult(
                context: context,
                isOperationSucceed: result.status == DocumentDataExtractionStatus.SUCCESS,
                dataTitle:  "GenericDocument",
                resultTextToShow: "Success",
            ));
  }

  Future<void> _recognizeCheckOnImage(BuildContext context) async {
    await startRecognizer<CheckScanningResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdk.recognizeOperations.recognizeCheckOnImage(
                path),
        handleResult: (result) =>
            handleRecognizedResult(
              context: context,
              isOperationSucceed: result.status == CheckMagneticInkStripScanningStatus.SUCCESS,
              dataTitle:  "Check",
              resultTextToShow: "Success",
            ));
  }

  Future<void> _recognizeCreditCardOnImage(BuildContext context) async {
    await startRecognizer<CreditCardScanningResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdk.recognizeOperations.recognizeCreditCardOnImage(
                path),
        handleResult: (result) =>
            handleRecognizedResult(
              context: context,
              isOperationSucceed: result.scanningStatus == CreditCardScanningStatus.SUCCESS,
              dataTitle:  "Credit Card",
              resultTextToShow: "Success",
            ));
  }

  Future<void> _startDocumentDataExtractorScanner(BuildContext context) async {
    await startDetector<ResultWrapper<DocumentDataExtractionResult>>(
      context: context,
      scannerFunction: () =>
          ScanbotSdkUi.showDocumentDataExtractor(
            DocumentDataExtractorScreenJsonConfiguration(
                topBarBackgroundColor: ScanbotRedColor,
                topBarButtonsActiveColor: Colors.white
            ),
          ),
      handleResult: (result) =>  {
        if (result.status == OperationStatus.OK) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GenericDocumentResultPreview(result.data!!),
            ),
          )
        }
      }
    );
  }

  Future<void> startVINScanner(BuildContext context) async {
    await startDetector<ResultWrapper<VinScannerResult>>(
        context: context,
        scannerFunction: () =>
            ScanbotSdkUi.startVinScanner(
              VinScannerJsonConfiguration(
                  topBarBackgroundColor: ScanbotRedColor,
                  topBarButtonsActiveColor: Colors.white
              ),
            ),
        handleResult: (result) =>  {
          if (result.status == OperationStatus.OK) {
            showResultTextDialog(context, result.data?.textResult)
          }
        }
    );
  }

  Future<void> startCheckScanner(BuildContext context) async {
    await startDetector<ResultWrapper<CheckScanningResult>>(
        context: context,
        scannerFunction: () =>
            ScanbotSdkUi.startCheckScanner(
              CheckScannerJsonConfiguration(
                  topBarBackgroundColor: ScanbotRedColor,
                  topBarButtonsActiveColor: Colors.white
              ),
            ),
        handleResult: (result) =>  {
          if (result.status == OperationStatus.OK) {
            showResultTextDialog(context, result.data?.status)
          }
        }
    );
  }

  Future<void> startTextDataScanner(BuildContext context) async {
    await startDetector<ResultWrapper<TextPatternScannerUiResult>>(
        context: context,
        scannerFunction: () =>
            ScanbotSdkUiV2.startTextDataScanner(
              TextPatternScannerScreenConfiguration(),
            ),
        handleResult: (result) =>  {
          if (result.status == OperationStatus.OK) {
            showResultTextDialog(context, jsonEncode(result.data))
          }
        }
    );
  }

  Future<void> startMedicalCertificateScanner(BuildContext context) async {
    await startDetector<ResultWrapper<MedicalCertificateScanningResult>>(
        context: context,
        scannerFunction: () =>
            ScanbotSdkUi.startMedicalCertificateScanner(
              MedicalCertificateScannerJsonConfiguration(
                  returnCroppedDocumentImage: false,
                  topBarBackgroundColor: ScanbotRedColor,
                  topBarButtonsActiveColor: Colors.white
              ),
            ),
        handleResult: (result) =>  {
          if (result.status == OperationStatus.OK) {
              showResultTextDialog(context, result.data?.patientInfoBox.toString())
          }
        }
    );
  }

  Future<void> startCreditCardScanner(BuildContext context) async {
    await startDetector<ResultWrapper<CreditCardScannerUiResult>>(
        context: context,
        scannerFunction: () =>
            ScanbotSdkUi.startCreditCardScanner(
              CreditCardScannerScreenConfiguration(),
            ),
        handleResult: (result) =>  {
          if (result.status == OperationStatus.OK) {
            showResultTextDialog(context, result.data?.toString())
          }
        }
    );
  }

  Future<void> startEhicScanner(BuildContext context) async {
    await startDetector<ResultWrapper<EuropeanHealthInsuranceCardRecognitionResult>>(
      context: context,
      scannerFunction: () => ScanbotSdkUi.startEhicScanner(
          HealthInsuranceCardScannerJsonConfiguration(
              topBarBackgroundColor: ScanbotRedColor,
              topBarButtonsActiveColor: Colors.white
          )
      ),
      handleResult: (result)  {
        if (result.status == OperationStatus.OK) {
          final resultString = result.data?.fields
              .map((field) =>
          "${field.type.toString().replaceAll("HealthInsuranceCardFieldType.", "")}: ${field.value}")
              .join("\n");

          showResultTextDialog(context, resultString);
        }
      },
    );
  }

  Future<void> startMRZScanner(BuildContext context) async {
    await startDetector<ResultWrapper<MrzScannerUiResult>>(
        context: context,
        scannerFunction: () =>
            ScanbotSdkUiV2.startMrzScanner(
              MrzScannerScreenConfiguration(),
            ),
        handleResult: (result) =>  {
          if (result.status == OperationStatus.OK) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MrzDocumentResultPreview(result.data!!)),
            )
          }
        }
    );
  }
}
