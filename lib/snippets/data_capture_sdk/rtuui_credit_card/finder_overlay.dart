import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = CreditCardScannerScreenConfiguration();
  /** Show the example overlay  */
  configuration.exampleOverlayVisible = true;
  //** Configure the view finder style */
  configuration.viewFinder.style = FinderCorneredStyle(
    cornerRadius: 8,
    strokeWidth: 2,
  );
  /** Start the Credit Card Scanner **/
  var result = await ScanbotSdkUiV2.startCreditCardScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}