import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

HealthInsuranceCardScannerJsonConfiguration healthInsuranceScannerConfigurationSnippet() {
  return HealthInsuranceCardScannerJsonConfiguration()
  // Behavior configuration:
  // e.g. turn on the flashlight.
  ..flashEnabled = true

  // UI configuration:
  // e.g. configure various colors.
  ..topBarButtonsActiveColor = Colors.white
  ..topBarBackgroundColor = Colors.red

  // Text configuration:
  // e.g. customize some UI elements' text.
  ..flashButtonTitle = "Flash"
  ..cancelButtonTitle = "Cancel";
}

Future<void> runEhicScanner() async {
  var config = healthInsuranceScannerConfigurationSnippet();
  var result = await ScanbotSdkUi.startEhicScanner(config);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}
