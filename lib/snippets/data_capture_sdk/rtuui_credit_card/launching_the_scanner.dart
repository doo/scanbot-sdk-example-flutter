import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = CreditCardScannerScreenConfiguration();
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
