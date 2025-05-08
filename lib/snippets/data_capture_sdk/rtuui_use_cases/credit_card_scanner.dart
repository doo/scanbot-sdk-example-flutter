import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

CreditCardScannerScreenConfiguration creditCardScannerConfigurationSnippet() {
  /**
   * Create the credit card scanner configuration object and
   * start the credit card scanner with the configuration
   */
  var configuration = CreditCardScannerScreenConfiguration();

  // Set colors
  configuration.palette.sbColorPrimary = ScanbotColor("#C8193C");
  configuration.palette.sbColorOnPrimary = ScanbotColor('#ffffff');

  // Add a top guidance title
  configuration.topUserGuidance.title = StyledText(
    text: 'Scan Credit Card',
    color: ScanbotColor("#FFFFFF"),
    useShadow: true,
  );

  // Modify the action bar
  configuration.actionBar.flipCameraButton.visible = false;
  configuration.actionBar.flashButton.activeForegroundColor = ScanbotColor("#1C1B1F");

  return configuration;
}

Future<void> runCreditCardScanner() async {
  var config = creditCardScannerConfigurationSnippet();
  var result = await ScanbotSdkUiV2.startCreditCardScanner(config);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}
