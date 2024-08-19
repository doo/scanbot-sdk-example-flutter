import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

Future<void> userGuidanceConfigSnippet() async {
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

  var result = await ScanbotSdkUi.startBarcodeScanner(configuration);
}
