import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = CheckScannerScreenConfiguration();
  // Show the introduction screen automatically when the screen appears.
  configuration.introScreen.showAutomatically = true;
  // Configure the title for the intro screen.
  configuration.introScreen.title = StyledText(
    color: ScanbotColor('#000000'),
    text: 'Check Scanner',
  );
  // Configure the image for the introduction screen.
  configuration.introScreen.image = CheckIntroCustomImage(
    uri: 'imageUri',
  );
  // Configure the text.
  configuration.introScreen.explanation.color = ScanbotColor('#000000');
  configuration.introScreen.explanation.text =
      'Quickly and securely scan your checks by holding your device over the check' +
          '\\nThe scanner will guide you to the optimal scanning position.' +
          'Once the scan is complete, your check details will automatically be extracted and processed.';
  // Configure the done button. E.g., the text or the background color.
  configuration.introScreen.doneButton.text = 'Start Scanning';
  configuration.introScreen.doneButton.background.fillColor = ScanbotColor('#C8193C');
  // Start the Check Scanner UI
  var result = await ScanbotSdkUiV2.startCheckScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}