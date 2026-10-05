import 'package:scanbot_sdk/scanbot_sdk.dart';

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
  var result = await ScanbotSdk.creditCard.startScanner(configuration);
  if (result is Ok<CreditCardScannerUiResult>) {
    /** Handle the result **/
    var scannerUiResult = result.value;
    // Display the extracted card data, e.g. card number and expiry date.
  } else {
    // Handle the error or cancellation, e.g. show a message to the user.
  }
}
