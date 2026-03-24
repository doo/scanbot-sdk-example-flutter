import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = VinScannerScreenConfiguration();
  /**  Retrieve the instance of the localization from the configuration object. */
  var localization = configuration.localization;
  /**  Configure the strings. */
  localization.topUserGuidance = 'Localized topUserGuidance';
  localization.cameraPermissionCloseButton =
      'Localized cameraPermissionCloseButton';
  localization.completionOverlaySuccessMessage =
      'Localized completionOverlaySuccessMessage';

  /** Start the VIN Scanner **/
  var result = await ScanbotSdk.vin.startScanner(configuration);
  if (result is Ok<VinScannerUiResult>) {
    /** Handle the result **/
    var scannerUiResult = result.value;
    print(scannerUiResult.toString());
  } else {
    print(result.toString());
  }
}
