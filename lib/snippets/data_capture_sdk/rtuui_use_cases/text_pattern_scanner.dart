import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

TextPatternScannerScreenConfiguration textPatternScannerConfigurationSnippet() {
  /**
   * Create the text pattern scanner configuration object and
   * start the text pattern scanner with the configuration
   */
  var configuration = TextPatternScannerScreenConfiguration();

  // Set colors
  configuration.palette.sbColorPrimary = ScanbotColor("#C8193C");
  configuration.palette.sbColorOnPrimary = ScanbotColor('#ffffff');

  // Modify the action bar
  configuration.actionBar.flipCameraButton.visible = false;
  configuration.actionBar.flashButton.activeForegroundColor = ScanbotColor("#1C1B1F");

  configuration.scannerConfiguration.minimumNumberOfRequiredFramesWithEqualScanningResult = 4;

  return configuration;
}

Future<void> runTextDataScanner() async {
  var config = textPatternScannerConfigurationSnippet();
  var result = await ScanbotSdkUiV2.startTextDataScanner(config);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}
