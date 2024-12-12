import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> documentScanner() async {
  var config = DocumentScannerConfiguration(
    ignoreBadAspectRatio: true,
    autoSnappingSensitivity: 0.67,
    topBarBackgroundColor: Colors.white,
    bottomBarBackgroundColor: Colors.white,
    textHintOK: "Don't move.\nCapturing document...",
    multiPageButtonHidden: true,
    multiPageEnabled: false,
  );

  var pageResult = await ScanbotSdkUi.startDocumentScanner(config);
}