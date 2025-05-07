import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = CreditCardScannerScreenConfiguration();
  /** Configure the top bar mode */
  configuration.topBar.mode = TopBarMode.GRADIENT;
  /** Configure the top bar status bar mode */
  configuration.topBar.statusBarMode = StatusBarMode.LIGHT;
  /** Configure the top bar background color */
  configuration.topBar.cancelButton.text = 'Cancel';
  configuration.topBar.cancelButton.foreground.color = ScanbotColor('#C8193C');
  /** Start the Credit Card Scanner **/
  var result = await ScanbotSdkUiV2.startCreditCardScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}