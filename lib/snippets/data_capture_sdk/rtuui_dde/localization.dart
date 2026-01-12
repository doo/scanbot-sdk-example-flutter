import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = DocumentDataExtractorScreenConfiguration();
  // Retrieve the instance of the localization from the configuration object.
  var localization = configuration.localization;
  //  Configure the strings.
  localization.topUserGuidance = 'Localized topUserGuidance';
  localization.cameraPermissionCloseButton =
      'Localized cameraPermissionCloseButton';
  localization.completionOverlaySuccessMessage =
      'Localized completionOverlaySuccessMessage';

  // Start the DDE
  var result = await ScanbotSdk.documentDataExtractor
      .startExtractorScreen(configuration);
  if (result is Ok<DocumentDataExtractorUiResult>) {
    /** Handle the result **/
    var documentDataExtractorUiResult = result.value;
  }
}
