import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:scanbot_sdk_example_flutter/snippets/data_capture_sdk/mrz_scanner_snippet.dart';

import '../snippets/data_capture_sdk/ehic_scanner_snippet.dart';
import '../snippets/data_capture_sdk/generic_document_scanner_snippet.dart';
import '../ui/menu_item_widget.dart';
import '../ui/preview/generic_document_preview.dart';
import '../ui/preview/mrz_document_preview.dart';
import '../utility/utils.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../snippets/data_capture_sdk/image_recognizers/detect_check_on_image_snippet.dart';
import '../snippets/data_capture_sdk/image_recognizers/detect_ehic_on_image_snippet.dart';
import '../snippets/data_capture_sdk/image_recognizers/detect_generic_doc_on_image_snippet.dart';
import '../snippets/data_capture_sdk/image_recognizers/detect_medical_certificate_on_image_snippet.dart';
import '../snippets/data_capture_sdk/image_recognizers/detect_mrz_on_image_snippet.dart';

import '../snippets/data_capture_sdk/check_scanner_snippet.dart';
import '../snippets/data_capture_sdk/license_plane_scanner_snippet.dart';
import '../snippets/data_capture_sdk/medical_scanner_snippet.dart';
import '../snippets/data_capture_sdk/text_data_scanner_snippet.dart';
import '../snippets/data_capture_sdk/vin_scanner_snippet.dart';

class DataCaptureUseCases extends StatelessWidget {
  const DataCaptureUseCases({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleItemWidget(title: 'Recognizers'),
        BuildMenuItem(context, "Recognize MRZ from Still Image", _recognizeMrzOnImage),
        BuildMenuItem(context, "Recognize Medical Certificate from Still Image", _recognizeMedicalCertificateOnImage),
        BuildMenuItem(context, "Recognize EHIC from Still Image", _recognizeHealthInsuranceCardOnImage),
        BuildMenuItem(context, "Recognize Generic Document from Still Image", _recognizeGenericDocumentOnImage),
        BuildMenuItem(context, "Recognize Check from Still Image", _recognizeCheckOnImage),
        const TitleItemWidget(title: 'Data Detectors'),
        BuildMenuItem(context, "Scan Generic Document", _startGenericDocumentScanner),
        BuildMenuItem(context, "Scan MRZ (Machine Readable Zone)", _startMRZScanner),
        BuildMenuItem(context, "Scan EHIC (European Health Insurance Card)", _startEhicScanner),
        BuildMenuItem(context, "Scan License Plate", startLicensePlateScanner),
        BuildMenuItem(context, "Scan VIN", startVINScanner),
        BuildMenuItem(context, "Scan Check", startCheckScanner),
        BuildMenuItem(context, "Scan Text Data", startTextDataScanner),
        BuildMenuItem(context, "Scan Medical Certificate", startMedicalCertificateScanner),
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
      final response = await ImagePicker().pickImage(source: ImageSource.gallery);
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
      await startRecognizer<MrzScanningResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdkRecognizeOperations.recognizeMrzOnImage(path),
        handleResult: (result) => handleRecognizedResult(
          context: context,
          isOperationSucceed: result.operationResult == OperationResult.SUCCESS,
          dataTitle: "Mrz",
          resultTextToShow: formatMrzResult(result),
      ));
  }

  Future<void> _recognizeMedicalCertificateOnImage(BuildContext context) async {
    await startRecognizer<MedicalCertificateResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdkRecognizeOperations.recognizeMedicalCertificateOnImage(path),
        handleResult: (result) => handleRecognizedResult(
            context: context,
            isOperationSucceed: (result.operationResult == OperationResult.SUCCESS && result.recognitionSuccessful == true),
            dataTitle: "Medical Certificate",
            resultTextToShow: formatMedicalCertificateResult(result),
        ));
  }

  Future<void> _recognizeHealthInsuranceCardOnImage(BuildContext context) async {
    await startRecognizer<HealthInsuranceCardRecognitionResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdkRecognizeOperations.recognizeHealthInsuranceCardOnImage(
                path),
        handleResult: (result) =>
            handleRecognizedResult(
                context: context,
                isOperationSucceed: (result.operationResult == OperationResult.SUCCESS && result.status == HealthInsuranceCardDetectionStatus.SUCCESS),
                dataTitle: "HealthInsuranceCard",
                resultTextToShow: formatHealthInsuranceCardResult(result),
            ));
  }

  Future<void> _recognizeGenericDocumentOnImage(BuildContext context) async {
    await startRecognizer<GenericDocumentRecognizerResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdkRecognizeOperations.recognizeGenericDocumentOnImage(
                path),
        handleResult: (result) =>
            handleRecognizedResult(
                context: context,
                isOperationSucceed: (result.operationResult == OperationResult.SUCCESS && result.status == GenericDocumentRecognitionStatus.Success),
                dataTitle:  "GenericDocument",
                resultTextToShow: formatGenericDocumentResult(result),
            ));
  }

  Future<void> _recognizeCheckOnImage(BuildContext context) async {
    await startRecognizer<CheckScanResult>(
        context: context,
        scannerFunction: (path) =>
            ScanbotSdkRecognizeOperations.recognizeCheckOnImage(
                path),
        handleResult: (result) =>
            handleRecognizedResult(
              context: context,
              isOperationSucceed: result.operationResult == OperationResult.SUCCESS,
              dataTitle:  "Check",
              resultTextToShow: formatCheckResult(result),
            ));
  }

  Future<void> _startGenericDocumentScanner(BuildContext context) async {
    await startDetector<GenericDocumentResults>(
      context: context,
      scannerFunction: () =>
          ScanbotSdkUi.startGenericDocumentRecognizer(
            genericDocumentRecognizerConfigurationSnippet(),
          ),
      handleResult: (result) =>  {
        if (result.operationResult == OperationResult.SUCCESS) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GenericDocumentResultPreview(result),
            ),
          )
        }
      }
    );
  }

  Future<void> startLicensePlateScanner(BuildContext context) async {
    await startDetector<LicensePlateScanResult>(
      context: context,
      scannerFunction: () =>
          ScanbotSdkUi.startLicensePlateScanner(
            licensePlateScannerConfigurationSnippet(),
          ),
      handleResult: (result) =>  {
        if (result.operationResult == OperationResult.SUCCESS) {
            showResultTextDialog(context, result.rawText)
        }
      }
    );
  }

  Future<void> startVINScanner(BuildContext context) async {
    await startDetector<VinScanResult>(
        context: context,
        scannerFunction: () =>
            ScanbotSdkUi.startVinScanner(
              vinScannerConfigurationSnippet(),
            ),
        handleResult: (result) =>  {
          if (result.operationResult == OperationResult.SUCCESS) {
            showResultTextDialog(context, result.rawText)
          }
        }
    );
  }

  Future<void> startCheckScanner(BuildContext context) async {
    await startDetector<CheckScanResult>(
        context: context,
        scannerFunction: () =>
            ScanbotSdkUi.startCheckScanner(
              checkScannerConfigurationSnippet(),
            ),
        handleResult: (result) =>  {
          if (result.operationResult == OperationResult.SUCCESS) {
            showResultTextDialog(context, result.check?.type.name)
          }
        }
    );
  }

  Future<void> startTextDataScanner(BuildContext context) async {
    await startDetector<TextDataScanResult>(
        context: context,
        scannerFunction: () =>
            ScanbotSdkUi.startTextDataScanner(
              textDataScannerConfigurationSnippet(),
            ),
        handleResult: (result) =>  {
          if (result.operationResult == OperationResult.SUCCESS) {
            showResultTextDialog(context, jsonEncode(result))
          }
        }
    );
  }

  Future<void> startMedicalCertificateScanner(BuildContext context) async {
    await startDetector<MedicalCertificateResult>(
        context: context,
        scannerFunction: () =>
            ScanbotSdkUi.startMedicalCertificateScanner(
              medicalCertificateScannerConfigurationSnippet(),
            ),
        handleResult: (result) =>  {
          if (result.operationResult == OperationResult.SUCCESS) {
              showResultTextDialog(context, result.patientInfoBox.toString())
          }
        }
    );
  }

  Future<void> _startEhicScanner(BuildContext context) async {
    await startDetector<HealthInsuranceCardRecognitionResult>(
      context: context,
      scannerFunction: () => ScanbotSdkUi.startEhicScanner(
        healthInsuranceScannerConfigurationSnippet(),
      ),
      handleResult: (result)  {
        if (result.operationResult == OperationResult.SUCCESS) {
          final resultString = result.fields
              .map((field) =>
          "${field.type.toString().replaceAll("HealthInsuranceCardFieldType.", "")}: ${field.value}")
              .join("\n");

          showResultTextDialog(context, resultString);
        }
      },
    );
  }

  Future<void> _startMRZScanner(BuildContext context) async {
    await startDetector<MrzScanningResult>(
        context: context,
        scannerFunction: () =>
            ScanbotSdkUi.startMrzScanner(
              mrzScannerConfigurationSnippet(),
            ),
        handleResult: (result) =>  {
          if (result.operationResult == OperationResult.SUCCESS) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MrzDocumentResultPreview(result)),
            )
          }
        }
    );
  }
}
