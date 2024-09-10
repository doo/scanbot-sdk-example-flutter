import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> runEhicScanner() async {
  var config = HealthInsuranceScannerConfiguration();

  // Behavior configuration:
  // e.g. turn on the flashlight.
  config.flashEnabled = true;

  // UI configuration:
  // e.g. configure various colors.
  config.topBarButtonsActiveColor = Colors.white;
  config.topBarBackgroundColor = Colors.red;

  // Text configuration:
  // e.g. customize some UI elements' text.
  config.flashButtonTitle = "Flash";
  config.cancelButtonTitle = "Cancel";

  var result = await ScanbotSdkUi.startEhicScanner(config);

  if (result.operationResult == OperationResult.SUCCESS) {
    // ...
  }
}
