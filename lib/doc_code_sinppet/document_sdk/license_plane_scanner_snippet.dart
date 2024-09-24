import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> runLicensePlaneScanner() async {
  var config = LicensePlateScannerConfiguration();

  // Behavior configuration:
  // e.g. set the maximum number of accumulated frames before starting recognition.
  config.maximumNumberOfAccumulatedFrames = 5;

  // UI configuration:
  // e.g. configure various colors.
  config.topBarBackgroundColor = Colors.red;
  config.topBarButtonsActiveColor = Colors.white;
  config.topBarButtonsInactiveColor = Colors.white.withAlpha(120);

  // Text configuration:
  // e.g. customize a UI element's text.
  config.cancelButtonTitle = "Cancel";

  var result = await ScanbotSdkUi.startLicensePlateScanner(config);

  if (result.operationResult == OperationResult.SUCCESS) {
    // ...
  }
}
