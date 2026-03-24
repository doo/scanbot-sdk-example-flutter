import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = CreditCardScannerScreenConfiguration();
  /** Retrieve the instance of the action bar from the configuration object. */
  var actionBar = configuration.actionBar;
  /** Configure the flash button */
  actionBar.flashButton.visible = true;
  actionBar.flashButton.backgroundColor = ScanbotColor('#C8193C');
  actionBar.flashButton.foregroundColor = ScanbotColor('#FFFFFF');
  /** Configure the zoom button */
  actionBar.zoomButton.visible = true;
  actionBar.zoomButton.backgroundColor = ScanbotColor('#C8193C');
  actionBar.zoomButton.foregroundColor = ScanbotColor('#FFFFFF');
  /** Hide the flip camera button */
  actionBar.flipCameraButton.visible = false;
  /** Start the Credit Card Scanner **/
  var result = await ScanbotSdk.creditCard.startScanner(configuration);
  if (result is Ok<CreditCardScannerUiResult>) {
    /** Handle the result **/
    var scannerUiResult = result.value;
    print(scannerUiResult.toString());
  } else {
    print(result.toString());
  }
}
