import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

LicensePlateScannerConfiguration licensePlateScannerConfigurationSnippet() {
  return LicensePlateScannerConfiguration()
    // Behavior configuration:
    // e.g. set the maximum number of accumulated frames before starting recognition.
    ..maximumNumberOfAccumulatedFrames = 5

    // UI configuration:
    // e.g. configure various colors.
    ..topBarBackgroundColor = Colors.red
    ..topBarButtonsActiveColor = Colors.white
    ..topBarButtonsInactiveColor = Colors.white.withAlpha(120)

    // Text configuration:
    // e.g. customize a UI element's text.
    ..cancelButtonTitle = "Cancel";
}

Future<void> runLicensePlaneScanner() async {
  var config = licensePlateScannerConfigurationSnippet();
  var result = await ScanbotSdkUi.startLicensePlateScanner(config);
  if (result.operationResult == OperationResult.SUCCESS) {
    // ...
  }
}
