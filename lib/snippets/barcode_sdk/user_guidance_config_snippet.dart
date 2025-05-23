import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

BarcodeScannerConfiguration userGuidanceConfigSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();

  // Hide/unhide the user guidance.
  configuration.userGuidance.visible = true;

  // Configure the title.
  configuration.userGuidance.title.text = "Move the finder over a barcode";
  configuration.userGuidance.title.color = ScanbotColor("#FFFFFF");

  // Configure the background.
  configuration.userGuidance.background.fillColor = ScanbotColor("#7A000000");

  // Configure other parameters as needed.

  return configuration;
}

Future<void> runBarcodeScanner() async {
  var configuration = userGuidanceConfigSnippet();
  var result = await ScanbotSdkUiV2.startBarcodeScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // TODO: present barcode result as needed
  }
}
