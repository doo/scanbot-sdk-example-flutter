import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

CheckScannerConfiguration checkScannerConfigurationSnippet() {
  return CheckScannerConfiguration(
      // Behavior configuration:
      // e.g. disable capturing the photo to recognize on live video stream
      captureHighResolutionImage: false,

      // UI configuration:
      // e.g. configure various colors.
      topBarBackgroundColor: Colors.red,
      topBarButtonsActiveColor: Colors.white,

      // Text configuration:
      // e.g. customize UI element's text.
      cancelButtonTitle: "Cancel",
  );
}

Future<void> runCheckScanner() async {
  var config = checkScannerConfigurationSnippet();
  var result = await ScanbotSdkUi.startCheckScanner(config);
  if (result.operationResult == OperationResult.SUCCESS) {
    // ...
  }
}
