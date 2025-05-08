import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart' as scanbot_sdk;

Future<void> runCroppingScreen(scanbot_sdk.Page page) async {
  var config = CroppingScreenConfiguration();
  // Behavior configuration:
  // e.g disable the rotation feature.
  config.rotateButtonHidden = false;

  // UI configuration:
  // e.g. configure various colors.
  config.topBarBackgroundColor = Colors.red;
  config.topBarButtonsColor = Colors.white;
  config.polygonColor = Colors.amberAccent;
  // config.polygonLineWidth = 10;

  // Text configuration:
  // e.g. customize a UI element's text
  config.cancelButtonTitle = "Cancel";
  config.doneButtonTitle = "Save";

  var result = await ScanbotSdkUi.startCroppingScreen(page, config);

  if (result.operationResult == OperationStatus.OK) {
    // ...
  }
}
