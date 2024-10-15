import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as scanbot_sdk;

Future<void> runTextDataScanner() async {
  var config = TextDataScannerConfiguration();

  // Behavior configuration:
  // e.g. enable highlighting of the detected word boxes.
  config.wordBoxHighlightEnabled = true;

  // UI configuration:
  // e.g. configure various colors.
  config.topBarBackgroundColor = Colors.red;
  config.topBarButtonsActiveColor = Colors.white;

  // Text configuration:
  // e.g. customize a UI element's text.
  config.cancelButtonTitle = "Cancel";

  // Create the data scanner step.
  var step = TextDataScannerStep(
      // Set the guidance text.
      "Scan a document",
      /// Validation pattern
      null,
      /// Set shouldMatchSubstring
      null,
      // Set the preferredZoom.
      0,
      // Set the aspect ratio.
      scanbot_sdk.AspectRatio(width: 4.0, height: 1.0),
      // Set the finder's unzoomed height.
      100,
      null,
      null,
  );

  // Set the guidance text.
  config.textDataScannerStep = step;

  var result = await ScanbotSdkUi.startTextDataScanner(config);

  if (result.operationResult == OperationResult.SUCCESS) {
    // ...
  }
}
