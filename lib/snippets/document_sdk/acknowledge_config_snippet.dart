import 'package:scanbot_sdk/scanbot_sdk.dart';

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
    // Set the background color for the acknowledgment screen.
    ..backgroundColor = ScanbotColor("#EFEFEF")
    // You can also configure the buttons in the bottom bar of the acknowledgment screen.
    // E.g., to force the user to retake, if the captured document is not OK.
    ..bottomBar.proceedAnywayButton.visible = false
    // Hide the titles of the buttons.
    ..documentNotFoundWarning.title.visible = false
    ..unacceptableQualityWarning.title.visible = false
    ..uncertainQualityWarning.title.visible = false;

  return configuration;
}

void runDocumentScanner() async {
  var configuration = acknowledgementConfigurationScanningFlow();
  var documentResult = await ScanbotSdk.document.startScanner(configuration);
  // Handle the document if the result is 'Ok'
  if (documentResult is Ok<DocumentData>) {
    var documentData = documentResult.value;
    print(documentData);
  } else {
    print(documentResult.toString());
  }
}
