import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as scanbot_sdk;

MrzScannerConfiguration mrzScannerConfigurationSnippet() {
  return MrzScannerConfiguration()
    // Behavior configuration:
    // e.g. enable a beep sound on successful detection.
    ..successBeepEnabled = true

    // UI configuration:
    // e.g. configure various colors and the finder's aspect ratio.
    ..topBarButtonsActiveColor = Colors.white
    ..topBarBackgroundColor = Colors.red
    ..finderAspectRatio = scanbot_sdk.AspectRatio(width: 1, height: 0.25)

    // Text configuration:
    // e.g. customize some UI elements' text.
    ..cancelButtonTitle = "Cancel"
    ..flashButtonTitle = "Flash"
  ;
}

Future<void> runMrzPageScanner() async {
  var config = mrzScannerConfigurationSnippet();
  var result = await ScanbotSdkUi.startMrzScanner(config);
  if (result.operationResult == OperationResult.SUCCESS) {
    // ...
  }
}
