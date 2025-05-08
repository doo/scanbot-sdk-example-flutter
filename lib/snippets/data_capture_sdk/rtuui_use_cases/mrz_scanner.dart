import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

MrzScannerScreenConfiguration mrzScannerConfigurationSnippet() {
  /**
   * Create the machine-readable zone scanner configuration object and
   * start the machine-readable zone scanner with the configuration
   */
  var configuration = MrzScannerScreenConfiguration();

  // Set colors
  configuration.palette.sbColorPrimary = ScanbotColor("#C8193C");
  configuration.palette.sbColorOnPrimary = ScanbotColor('#ffffff');

  // Add a top guidance title
  configuration.topUserGuidance.title = StyledText(
    text: 'Scan MRZ',
    color: ScanbotColor("#FFFFFF"),
    useShadow: true,
  );

  // Modify the action bar
  configuration.actionBar.flipCameraButton.visible = false;
  configuration.actionBar.flashButton.activeForegroundColor = ScanbotColor("#1C1B1F");

  // Configure the scanner
  configuration.scannerConfiguration.incompleteResultHandling = MrzIncompleteResultHandling.ACCEPT;

  return configuration;
}

Future<void> runMrzScanner() async {
  var config = mrzScannerConfigurationSnippet();
  var result = await ScanbotSdkUiV2.startMrzScanner(config);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}
