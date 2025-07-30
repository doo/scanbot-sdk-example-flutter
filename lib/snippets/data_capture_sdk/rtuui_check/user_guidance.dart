import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = CheckScannerScreenConfiguration();
  // Retrieve the instance of the top user guidance from the configuration object.
  var topUserGuidance = configuration.topUserGuidance;
  // Show the top user guidance
  topUserGuidance.visible = true;
  // Customize the top user guidance
  topUserGuidance.title.text = 'Customized title';
  topUserGuidance.title.color = ScanbotColor('#000000');
  // Customize the top user guidance background
  topUserGuidance.background.fillColor = ScanbotColor('#C8193C');
  // Retrieve the instance of the scan status user guidance from the configuration object.
  var scanStatusUserGuidance = configuration.scanStatusUserGuidance;
  // Customize the scan status user guidance
  scanStatusUserGuidance.title.text = 'Customized title';
  scanStatusUserGuidance.title.color = ScanbotColor('#000000');
  // Customize the scan status guidance background
  scanStatusUserGuidance.background.fillColor = ScanbotColor('#C8193C');
  // Start the Check Scanner UI
  var result = await ScanbotSdkUiV2.startCheckScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}