import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> runCheckScanner() async {
  var config = CheckScannerConfiguration();

  // Behavior configuration:
  // e.g. disable capturing the photo to recognize on live video stream
  config.captureHighResolutionImage = false;

  // UI configuration:
  // e.g. configure various colors.
  config.topBarBackgroundColor = Colors.red;
  config.topBarButtonsActiveColor = Colors.white;

  // Text configuration:
  // e.g. customize UI element's text.
  config.cancelButtonTitle = "Cancel";

  var result = await ScanbotSdkUi.startCheckScanner(config);

  if (result.operationResult == OperationResult.SUCCESS) {
    // ...
  }
}
