import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = TextPatternScannerScreenConfiguration();
  /** Retrieve the instance of the top user guidance from the configuration object. */
  var topUserGuidance = configuration.topUserGuidance;
  /** Show the top user guidance */
  topUserGuidance.visible = true;
  /** Customize the top user guidance */
  topUserGuidance.title.text = 'Customized title';
  topUserGuidance.title.color = ScanbotColor('#000000');
  /** Customize the top user guidance background */
  topUserGuidance.background.fillColor = ScanbotColor('#C8193C');
  /** Retrieve the instance of the finder user guidance from the configuration object. */
  var finderUserGuidance = configuration.finderViewUserGuidance;
  /** Show the finder user guidance */
  finderUserGuidance.visible = true;
  /** Customize the finder user guidance */
  finderUserGuidance.title.text = 'Customized title';
  finderUserGuidance.title.color = ScanbotColor('#000000');
  /** Customize the finder user guidance background */
  finderUserGuidance.background.fillColor = ScanbotColor('#C8193C');
  /** Start the Text Pattern Scanner **/
  var result = await ScanbotSdkUiV2.startTextPatternScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}