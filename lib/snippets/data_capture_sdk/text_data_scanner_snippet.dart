import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as scanbot_sdk;
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

TextPatternScannerScreenConfiguration textDataScannerConfigurationSnippet() {
  return TextPatternScannerScreenConfiguration();
    // // Behavior configuration:
    // // e.g. enable highlighting of the detected word boxes.
    // ..wordBoxHighlightEnabled = true
    //
    // // UI configuration:
    // // e.g. configure various colors.
    // ..topBarBackgroundColor = Colors.red
    // ..topBarButtonsActiveColor = Colors.white
    //
    // // Text configuration:
    // // e.g. customize a UI element's text.
    // ..cancelButtonTitle = "Cancel"
    //
    // // Set the guidance text and other properties.
    // ..textDataScannerStep = TextDataScannerStep(
    //   // Set the guidance text.
    //   "Scan a document",
    //
    //   /// Validation pattern
    //   null,
    //
    //   /// Set shouldMatchSubstring
    //   null,
    //   // Set the preferredZoom.
    //   0,
    //   // Set the aspect ratio.
    //   scanbot_sdk.AspectRatio(width: 4.0, height: 1.0),
    //   // Set the finder's unzoomed height.
    //   100,
    //   null,
    //   null,
    // );
}

Future<void> runTextDataScanner() async {
  var config = textDataScannerConfigurationSnippet();
  var result = await ScanbotSdkUiV2.startTextDataScanner(config);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}
