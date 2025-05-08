import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = CreditCardScannerScreenConfiguration();
  /**  Retrieve the instance of the localization from the configuration object. */
  var localization = configuration.localization;
  /**  Configure the strings. */
  localization.topUserGuidance = 'Localized topUserGuidance';
  localization.cameraPermissionCloseButton =
  'Localized cameraPermissionCloseButton';
  localization.completionOverlaySuccessMessage =
  'Localized completionOverlaySuccessMessage';
  localization.creditCardUserGuidanceNoCardFound =
  'Localized creditCardUserGuidanceNoCardFound';
  /** Start the Credit Card Scanner **/
  var result = await ScanbotSdkUiV2.startCreditCardScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}