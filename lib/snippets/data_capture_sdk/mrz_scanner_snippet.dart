import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as scanbot_sdk;
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

MrzScannerScreenConfiguration mrzScannerConfigurationSnippet() {
  var screenConfiguration = MrzScannerScreenConfiguration();

  return screenConfiguration;
}

Future<void> runMrzPageScanner() async {
  var config = mrzScannerConfigurationSnippet();
  var result = await ScanbotSdkUiV2.startMrzScanner(config);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}
