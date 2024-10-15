import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> runMedicalDocumentPageScanner() async {
  var config = MedicalCertificateScannerConfiguration();
  // Behavior configuration:
  // e.g. disable recognition of patient's personal information.
  config.recognizePatientInfo = false;

  // UI configuration:
  // e.g. configure various colors.
  config.topBarBackgroundColor = Colors.red;
  config.topBarButtonsActiveColor = Colors.white;

  // Text configuration:
  // e.g. customize UI element's text.
  config.cancelButtonTitle = "Cancel";

  var result = await ScanbotSdkUi.startMedicalCertificateScanner(config);

  if (result.operationResult == OperationResult.SUCCESS) {
    // ...
  }
}
