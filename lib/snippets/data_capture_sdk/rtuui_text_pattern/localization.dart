import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = TextPatternScannerScreenConfiguration();
  var localization = configuration.localization;
  /**  Configure the strings. */
  localization.topUserGuidance = 'Localized topUserGuidance';
  localization.cameraPermissionCloseButton =
      'Localized cameraPermissionCloseButton';
  localization.completionOverlaySuccessMessage =
      'Localized completionOverlaySuccessMessage';
  localization.finderViewUserGuidance = 'Localized finderViewUserGuidance';
  localization.introScreenTitle = 'Localized introScreenTitle';
  /** Start the Text Pattern Scanner **/
  var result = await ScanbotSdk.textPattern.startScanner(configuration);
  if (result is Ok<TextPatternScannerUiResult>) {
    /** Handle the result **/
    var scannerUiResult = result.value;
    // Use the recognized text, e.g. display it or fill in a form field.
  } else {
    // Handle the error or cancellation, e.g. show a message to the user.
  }
}
