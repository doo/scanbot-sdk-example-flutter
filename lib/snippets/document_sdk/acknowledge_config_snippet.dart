import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

DocumentScanningFlow acknowledgementConfigurationScanningFlow() {
  // Create the default configuration object.
  var configuration = DocumentScanningFlow();

  configuration.screens.camera.acknowledgement
      // Set the acknowledgment mode
      // Modes:
      // - `ALWAYS`: Runs the quality analyzer on the captured document and always displays the acknowledgment screen.
      // - `BAD_QUALITY`: Runs the quality analyzer and displays the acknowledgment screen only if the quality is poor.
      // - `NONE`: Skips the quality check entirely.
      ..acknowledgementMode = AcknowledgementMode.ALWAYS

      // Set the minimum acceptable document quality.
      // Options: excellent, good, reasonable, poor, veryPoor, or noDocument.
      ..minimumQuality = DocumentQuality.REASONABLE

      // Set the background color for the acknowledgment screen.
      ..backgroundColor = ScanbotColor("#EFEFEF")

      // You can also configure the buttons in the bottom bar of the acknowledgment screen.
      // e.g To force the user to retake, if the captured document is not OK.
      ..bottomBar.acceptWhenNotOkButton.visible = false

      // Hide the titles of the buttons.
      ..bottomBar.acceptWhenNotOkButton.title.visible = false
      ..bottomBar.acceptWhenOkButton.title.visible = false
      ..bottomBar.retakeButton.title.visible = false

      // Configure the acknowledgment screen's hint message which is shown if the least acceptable quality is not met.
      ..badImageHint.visible = true;

  return configuration;
}

void runDocumentScanner() async {
  var configuration = acknowledgementConfigurationScanningFlow();
  await ScanbotSdkUiV2.startDocumentScanner(configuration);
}
