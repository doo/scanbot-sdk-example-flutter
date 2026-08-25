import 'package:scanbot_sdk/scanbot_sdk.dart';

DocumentScanningFlow createDocumentScanningFlowConfiguration() {
  // Create the default configuration object.
  var configuration = DocumentScanningFlow();

  // Configure the review screen.
  var reviewScreen = configuration.screens.review;
  reviewScreen
    ..enabled = true
    ..zoomButton.visible = false
    ..toolBar.addButton.barButton.visible = false
    ..toolBar.retakeButton.barButton.visible = true
    ..toolBar.retakeButton.barButton.title.color = ScanbotColor("000000");

  // Configure the reorder pages screen.
  var reorderPagesScreen = configuration.screens.reorderPages;
  reorderPagesScreen
    ..guidance.visible = false
    ..topBarTitle.text = "Reorder Pages Screen";

  // Configure the cropping screen.
  configuration.screens.cropping.toolBar.resetButton.visible = false;

  return configuration;
}

void runDocumentScanner() async {
  var configuration = createDocumentScanningFlowConfiguration();
  var documentResult = await ScanbotSdk.document.startScanner(configuration);
  // Handle the document if the result is 'Ok'
  if (documentResult is Ok<DocumentData>) {
    var documentData = documentResult.value;
    print(documentData);
  } else {
    print(documentResult.toString());
  }
}
