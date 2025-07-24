import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = VinScannerScreenConfiguration();
  /** Retrieve the instance of the top user guidance from the configuration object. */
  var topUserGuidance = configuration.topUserGuidance;
  /** Show the top user guidance */
  topUserGuidance.visible = true;
  /** Customize the top user guidance */
  topUserGuidance.title.text = "Locate the VIN you are looking for";
  topUserGuidance.title.color = ScanbotColor('#000000');
  /** Customize the top user guidance background */
  topUserGuidance.background.fillColor = ScanbotColor('#C8193C');
  /** Retrieve the instance of the scan status user guidance from the configuration object. */
  var finderUserGuidance = configuration.finderViewUserGuidance;
  /** Customize the status user guidance text */
  finderUserGuidance.title.text = "Scanning for VIN...";
  finderUserGuidance.title.color = ScanbotColor('#000000');
  /** Customize the status user guidance background */
  finderUserGuidance.background.fillColor = ScanbotColor('#C8193C');
  /** Start the Credit Card Scanner **/
  var result = await ScanbotSdkUiV2.startVINScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}