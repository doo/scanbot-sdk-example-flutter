import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = DocumentDataExtractorScreenConfiguration();
  // Retrieve the instance of the top user guidance from the configuration object.
  var topUserGuidance = configuration.topUserGuidance;
  // Show the user guidance.
  topUserGuidance.visible = true;
  // Configure the title.
  topUserGuidance.title.text = "Scan your Identity Document";
  topUserGuidance.title.color = ScanbotColor("#FFFFFF");
  // Configure the background.
  topUserGuidance.background.fillColor = ScanbotColor("#7A000000");

  // Scan status user guidance
  // Retrieve the instance of the user guidance from the configuration object.
  var scanStatusUserGuidance = configuration.scanStatusUserGuidance;
  // Show the user guidance.
  scanStatusUserGuidance.visibility = true;
  // Configure the title.
  scanStatusUserGuidance.title.text = "Scan document";
  scanStatusUserGuidance.title.color = ScanbotColor("#FFFFFF");
  // Configure the background.
  scanStatusUserGuidance.background.fillColor = ScanbotColor("#7A000000");
  // Start the DDE
  var result = await ScanbotSdkUiV2.startDocumentDataExtractor(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}