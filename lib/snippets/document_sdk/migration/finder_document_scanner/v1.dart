import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

Future<void> finderDocumentScanner() async {
  var configuration = FinderDocumentScannerConfiguration(
    topBarBackgroundColor: Colors.white,
    shutterButtonHidden: true,
    // finderAspectRatio: AspectRatio(width: 3, height: 4),
  );

  var pageResult = await ScanbotSdkUi.startFinderDocumentScanner(configuration);
}