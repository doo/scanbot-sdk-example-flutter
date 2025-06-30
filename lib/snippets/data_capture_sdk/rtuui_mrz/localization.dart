import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

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
  var result = await ScanbotSdkUiV2.startMrzScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}