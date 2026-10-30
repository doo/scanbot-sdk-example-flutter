import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = CheckScannerScreenConfiguration();
  // Start the Check Scanner
  var result = await ScanbotSdk.check.startScanner(configuration);
  if (result is Ok<CheckScannerUiResult>) {
    /** Handle the result **/
    var scannerUiResult = result.value;
    // Display the extracted check data, e.g. account and routing numbers.
  } else {
    // Handle the error or cancellation, e.g. show a message to the user.
  }
}
