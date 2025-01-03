import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

VinScannerConfiguration vinScannerConfigurationSnippet() {
  return VinScannerConfiguration()
  // Behavior configuration:
  // e.g. set the maximum number of accumulated frames.
  ..minimumNumberOfRequiredFramesWithEqualRecognitionResult = 4

  // UI configuration:
  ..topBarBackgroundColor = Colors.red
  ..topBarButtonsActiveColor = Colors.white
  ..topBarButtonsInactiveColor = Colors.lightBlue

  // Text configuration:
  ..guidanceText = "Scan Vin"
  ..cancelButtonTitle = "Cancel";
}

Future<void> runVinScanner() async {
  var config = vinScannerConfigurationSnippet();
  var result = await ScanbotSdkUi.startVinScanner(config);
  if (result.operationResult == OperationResult.SUCCESS) {
    // ...
  }
}
