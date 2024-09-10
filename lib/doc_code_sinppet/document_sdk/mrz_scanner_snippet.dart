import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as scanbot_sdk;

Future<void> runMrzPageScanner() async {
  var config = MrzScannerConfiguration();

  // Behavior configuration:
  // e.g. enable a beep sound on successful detection.
  config.successBeepEnabled = true;

  // UI configuration:
  // e.g. configure various colors and the finder's aspect ratio.
  config.topBarButtonsActiveColor = Colors.white;
  config.topBarBackgroundColor = Colors.red;
  config.finderAspectRatio = scanbot_sdk.AspectRatio(width: 1, height: 0.25);

  // Text configuration:
  // e.g. customize some UI elements' text.
  config.cancelButtonTitle = "Cancel";
  config.flashButtonTitle = "Flash";

  var result = await ScanbotSdkUi.startMrzScanner(config);

  if (result.operationResult == OperationResult.SUCCESS) {
    // ...
  }
}
