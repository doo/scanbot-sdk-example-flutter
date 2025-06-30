import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

MedicalCertificateScannerConfiguration medicalCertificateScannerConfigurationSnippet() {
  return MedicalCertificateScannerConfiguration()
    // Behavior configuration:
    // e.g. disable recognition of patient's personal information.
    // ..recognizePatientInfo = false

    // UI configuration:
    // e.g. configure various colors.
    ..topBarBackgroundColor = Colors.red
    ..topBarButtonsActiveColor = Colors.white

    // Configuration for the hint values:
    // If you do not set your own values, the default ones will be used.
    // ..userGuidanceStrings = MedicalCertificateUserGuidanceStrings(
    //     "Start scanning",
    //     "Scanning",
    //     "Energy saving",
    //     "Capturing",
    //     "Processing",
    //     "Paused")

    // Text configuration:
    // e.g. customize UI element's text.
    ..cancelButtonTitle = "Cancel";
}

Future<void> runMedicalDocumentPageScanner() async {
  var config = medicalCertificateScannerConfigurationSnippet();
  var result = await ScanbotSdkUi.startMedicalCertificateScanner(config);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}
