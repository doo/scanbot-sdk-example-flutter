import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = TextPatternScannerScreenConfiguration();
  /** Configure the top bar mode */
  configuration.topBar.mode = TopBarMode.GRADIENT;
  /** Configure the top bar status bar mode */
  configuration.topBar.statusBarMode = StatusBarMode.LIGHT;
  /** Configure the top bar background color */
  configuration.topBar.cancelButton.text = 'Cancel';
  configuration.topBar.cancelButton.foreground.color = ScanbotColor('#C8193C');
  /** Start the Text Pattern Scanner **/
  var result = await ScanbotSdk.textPattern.startScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}