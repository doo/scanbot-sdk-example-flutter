import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = CreditCardScannerScreenConfiguration();
  /** Retrieve the instance of the introduction configuration from the main configuration object. */
  var introductionConfiguration = configuration.introScreen;
  /** Show the introduction screen automatically when the screen appears. */
  introductionConfiguration.showAutomatically = true;
  /** Configure the title for the intro screen. */
  introductionConfiguration.title = StyledText(
    color: ScanbotColor('#000000'),
    text: 'Credit Card Scanner',
  );
  /** Configure the image for the introduction screen. */
  introductionConfiguration.image = CreditCardIntroCustomImage(
    uri: 'imageUri',
  );
  /** Configure the text. **/
  configuration.introScreen.explanation.color = ScanbotColor('#000000');
  configuration.introScreen.explanation.text =
  "To quickly and securely input your credit card details, please hold your device over the credit card, so that the camera aligns with the numbers on the front of the card.\n\nThe scanner will guide you to the optimal scanning position. Once the scan is complete, your card details will automatically be extracted and processed.\n\nPress 'Start Scanning' to begin.";
  /** Configure the done button. E.g., the text or the background color. **/
  configuration.introScreen.doneButton.text = 'Start Scanning';
  configuration.introScreen.doneButton.background.fillColor = ScanbotColor('#C8193C');
  /** Start the Credit Card Scanner **/
  var result = await ScanbotSdkUiV2.startCreditCardScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}