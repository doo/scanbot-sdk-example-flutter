import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = TextPatternScannerScreenConfiguration();
  /** Retrieve the instance of the introduction configuration from the main configuration object. */
  var introductionConfiguration = configuration.introScreen;
  /** Show the introduction screen automatically when the screen appears. */
  introductionConfiguration.showAutomatically = true;
  /** Configure the title for the intro screen. */
  introductionConfiguration.title = StyledText(
    color: ScanbotColor('#000000'),
    text: 'Text Pattern Scanner',
  );
  /** Configure the image for the introduction screen. */
  introductionConfiguration.image = TextPatternIntroCustomImage(
    uri: 'imageUri',
  );
  /** Configure the text. **/
  configuration.introScreen.explanation.color = ScanbotColor('#000000');
  configuration.introScreen.explanation.text =
  "To scan a single line of text, please hold your device so that the camera viewfinder clearly captures the text you want to scan. Please ensure the text is properly aligned. Once the scan is complete, the text will be automatically extracted.\n\nPress 'Start Scanning' to begin.";
  /** Configure the done button. E.g., the text or the background color. **/
  configuration.introScreen.doneButton.text = 'Start Scanning';
  configuration.introScreen.doneButton.background.fillColor = ScanbotColor('#C8193C');
  /** Start the Text Pattern Scanner **/
  var result = await ScanbotSdkUiV2.startTextPatternScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}