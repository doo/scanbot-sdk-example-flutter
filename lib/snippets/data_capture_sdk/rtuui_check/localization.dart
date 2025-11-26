import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = CheckScannerScreenConfiguration();
  // Configure the strings.
  configuration.localization.topUserGuidance = 'Localized topUserGuidance';
  configuration.localization.cameraPermissionCloseButton = 'Localized cameraPermissionCloseButton';
  configuration.localization.completionOverlaySuccessMessage = 'Localized completionOverlaySuccessMessage';
  configuration.localization.introScreenText = 'Localized introScreenText';
  // Start the Check Scanner UI
  var result = await ScanbotSdk.check.startScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}