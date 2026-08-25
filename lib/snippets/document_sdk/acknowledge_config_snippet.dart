import 'package:scanbot_sdk/scanbot_sdk.dart';

DocumentScanningFlow acknowledgementConfigurationScanningFlow() {
  // Create the default configuration object.
  var configuration = DocumentScanningFlow();

  configuration.screens.camera.acknowledgement
    // Set the acknowledgment mode
    // Modes:
    // - UNACCEPTABLE_QUALITY: The acknowledgment screen will only be shown when the quality of a scanned page is unacceptable. The quality threshold is determined by the document quality analyzer parameters.
    // - ALWAYS: The acknowledgment screen will always be shown after each snap, regardless of the scanned page's quality.
    // - NONE: The acknowledgment screen will be disabled, in effect never shown.
    ..acknowledgementMode = AcknowledgementMode.ALWAYS
    // Set the background color for the acknowledgment screen.
    ..backgroundColor = ScanbotColor("#EFEFEF")
    // You can also configure the buttons in the bottom bar of the acknowledgment screen.
    // E.g., to force the user to retake, if the captured document is not OK.
    ..toolBar.proceedAnywayButton.visible = false
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
