import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

Future<void> documentScanner() async {
  var config = DocumentScannerScreenConfiguration(
    ignoreOrientationMismatch: true,
    autoSnappingSensitivity: 0.67,
    topBarBackgroundColor: Colors.white,
    bottomBarBackgroundColor: Colors.white,
    textHintOK: "Don't move.\nCapturing document...",
    multiPageButtonHidden: true,
    multiPageEnabled: false,
  );

  var pageResult = await ScanbotSdkUi.startDocumentScanner(config);
}