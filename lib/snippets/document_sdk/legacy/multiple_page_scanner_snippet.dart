import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

Future<void> runMultiPageScanner() async {
  var config = DocumentScannerConfiguration();
  config.multiPageEnabled = true;
  config.multiPageButtonHidden = false;
  config.shutterButtonAutoInnerColor = Colors.red;
  config.shutterButtonManualInnerColor = Colors.red;

  var result = await ScanbotSdkUi.startDocumentScanner(config);
}
