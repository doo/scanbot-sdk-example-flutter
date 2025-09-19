import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = CheckScannerScreenConfiguration();
  // Configure the flash button
  configuration.actionBar.flashButton.visible = true;
  configuration.actionBar.flashButton.backgroundColor = ScanbotColor('#C8193C');
  configuration.actionBar.flashButton.foregroundColor = ScanbotColor('#FFFFFF');
  // Configure the zoom button
  configuration.actionBar.zoomButton.visible = true;
  configuration.actionBar.zoomButton.backgroundColor = ScanbotColor('#C8193C');
  configuration.actionBar.zoomButton.foregroundColor = ScanbotColor('#FFFFFF');
  // Hide the flip camera button
  configuration.actionBar.flipCameraButton.visible = false;
  // Start the Check Scanner
  var result = await ScanbotSdkUiV2.startCheckScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}