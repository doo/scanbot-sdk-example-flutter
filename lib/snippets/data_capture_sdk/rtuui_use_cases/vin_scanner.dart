import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

VinScannerJsonConfiguration vinScannerConfigurationSnippet() {
  return VinScannerJsonConfiguration()
  // Behavior configuration:
  // e.g. set the maximum number of accumulated frames.
  // ..minimumNumberOfRequiredFramesWithEqualRecognitionResult = 4

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
  if (result.status == OperationStatus.OK) {
    // ...
  }
}
