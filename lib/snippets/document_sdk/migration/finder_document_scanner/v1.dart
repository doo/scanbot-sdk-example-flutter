import 'package:flutter/material.dart' show Colors;
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> finderDocumentScanner() async {
  var configuration = FinderDocumentScannerConfiguration(
    topBarBackgroundColor: Colors.white,
    shutterButtonHidden: true,
    // finderAspectRatio: AspectRatio(width: 3, height: 4),
  );

  var pageResult = await ScanbotSdkUi.startFinerDocumentScanner(configuration);
}