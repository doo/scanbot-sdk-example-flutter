import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = CreditCardScannerScreenConfiguration();
  /** Start the Credit Card Scanner **/
  var result = await ScanbotSdkUiV2.startCreditCardScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}