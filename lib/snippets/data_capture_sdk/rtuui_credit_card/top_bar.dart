import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = CreditCardScannerScreenConfiguration();
  /** Configure the top bar mode */
  configuration.topBar.mode = TopBarMode.SOLID;
  /** Configure the top bar background color */
  configuration.topBar.backgroundColor = ScanbotColor('#C8193C');
  /** Configure the top bar status bar mode */
  configuration.topBar.statusBarMode = StatusBarMode.LIGHT;
  /** Configure the cancel button */
  configuration.topBar.cancelButton.text = 'Cancel';
  configuration.topBar.cancelButton.foreground.color = ScanbotColor('#FFFFFF');
  /** Start the Credit Card Scanner **/
  var result = await ScanbotSdk.creditCard.startScanner(configuration);
  if (result is Ok<CreditCardScannerUiResult>) {
    /** Handle the result **/
    var scannerUiResult = result.value;
    // Display the extracted card data, e.g. card number and expiry date.
  } else {
    // Handle the error or cancellation, e.g. show a message to the user.
  }
}
