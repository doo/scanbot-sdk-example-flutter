import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = MrzScannerScreenConfiguration();
  /**  Retrieve the instance of the localization from the configuration object. */
  var localization = configuration.localization;
  /**  Configure the strings. */
  localization.topUserGuidance = 'Localized topUserGuidance';
  localization.cameraPermissionCloseButton =
      'Localized cameraPermissionCloseButton';
  localization.completionOverlaySuccessMessage =
      'Localized completionOverlaySuccessMessage';
  localization.finderViewUserGuidance = 'Localized finderViewUserGuidance';
  /** Start the MRZ Scanner UI */
  var result = await ScanbotSdk.mrz.startScanner(configuration);
  if (result is Ok<MrzScannerUiResult>) {
    /** Handle the result **/
    var scannerUiResult = result.value;
  }
}
