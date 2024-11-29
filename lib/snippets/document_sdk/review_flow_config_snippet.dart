import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

DocumentScanningFlow createDocumentScanningFlowConfiguration() {
  // Create the default configuration object.
  var configuration = DocumentScanningFlow();

  // Configure the review screen.
  var reviewScreen = configuration.screens.review;
  reviewScreen
    ..enabled = true
    ..zoomButton.visible = false
    ..bottomBar.addButton.visible = false
    ..bottomBar.retakeButton.visible = true
    ..bottomBar.retakeButton.title.color = ScanbotColor("000000");

  // Configure the reorder pages screen.
  var reorderPagesScreen = configuration.screens.reorderPages;
  reorderPagesScreen
    ..guidance.visible = false
    ..topBarTitle.text = "Reorder Pages Screen";

  // Configure the cropping screen.
  configuration.screens.cropping.bottomBar.resetButton.visible = false;

  return configuration;
}

void runDocumentScanner() async {
  var configuration = createDocumentScanningFlowConfiguration();
  await ScanbotSdkUiV2.startDocumentScanner(configuration);
}
