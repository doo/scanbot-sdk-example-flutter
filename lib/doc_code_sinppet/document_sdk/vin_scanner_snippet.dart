import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> runVinScanner() async {
  var config = VinScannerConfiguration();

  // Behavior configuration:
  // e.g. set the maximum number of accumulated frames.
  config.minimumNumberOfRequiredFramesWithEqualRecognitionResult = 4;

  // UI configuration:
  config.topBarBackgroundColor = Colors.red;
  config.topBarButtonsActiveColor = Colors.white;
  config.topBarButtonsInactiveColor = Colors.lightBlue;

  // Text configuration:
  config.guidanceText = "Scan Vin";
  config.cancelButtonTitle = "Cancel";


  var result = await ScanbotSdkUi.startVinScanner(config);

  if (result.operationResult == OperationResult.SUCCESS) {
    // ...
  }
}
