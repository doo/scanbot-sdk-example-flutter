import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = VinScannerScreenConfiguration();
  /** Configure the view finder style */
  configuration.viewFinder.style = FinderCorneredStyle(
    cornerRadius: 8,
    strokeWidth: 2,
  );
  /** Start the VIN Scanner **/
  var result = await ScanbotSdk.vin.startScanner(configuration);
  if (result is Ok<VinScannerUiResult>) {
    /** Handle the result **/
    var scannerUiResult = result.value;
    // Use the recognized VIN, e.g. look up the vehicle details.
  } else {
    // Handle the error or cancellation, e.g. show a message to the user.
  }
}
