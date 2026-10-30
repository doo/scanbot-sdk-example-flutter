import 'package:scanbot_sdk/scanbot_sdk.dart';

DocumentScanningFlow createDocumentScanningFlowConfiguration() {
  // Create the default configuration object.
  var configuration = DocumentScanningFlow();

  // Configure the review screen.
  var reviewScreen = configuration.screens.review;
  reviewScreen
    ..enabled = true
    ..zoomButton.visible = false
    ..toolbar.addButton.barButton.visible = false
    ..toolbar.retakeButton.barButton.visible = true
    ..toolbar.retakeButton.barButton.title.color = ScanbotColor("000000");

  // Configure the reorder pages screen.
  var reorderPagesScreen = configuration.screens.reorderPages;
  reorderPagesScreen
    ..guidance.visible = false
    ..topBarTitle.text = "Reorder Pages Screen";

  // Configure the cropping screen.
  configuration.screens.cropping.toolbar.resetButton.visible = false;

  return configuration;
}

void runDocumentScanner() async {
  var configuration = createDocumentScanningFlowConfiguration();
  var documentResult = await ScanbotSdk.document.startScanner(configuration);
  // Handle the document if the result is 'Ok'
  if (documentResult is Ok<DocumentData>) {
    var documentData = documentResult.value;
    // Display the scanned pages, or export the document as PDF/TIFF.
  } else {
    // Handle the error or cancellation, e.g. show a message to the user.
  }
}
