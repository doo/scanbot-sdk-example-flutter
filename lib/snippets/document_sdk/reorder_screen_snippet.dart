import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

void reorderScreen() async {
  // Create the default configuration object.
  var configuration = DocumentScanningFlow();

  // Retrieve the instance of the reorder pages configuration from the main configuration object.
  var reorderScreenConfiguration = configuration.screens.reorderPages;
  // Hide the guidance view.
  reorderScreenConfiguration.guidance.visible = false;
  // Set the title for the reorder screen.
  reorderScreenConfiguration.topBarTitle.text = 'Reorder Pages Screen';
  // Set the title for the guidance.
  reorderScreenConfiguration.guidance.title.text = 'Reorder';
  // Set the color for the page number text.
  reorderScreenConfiguration.pageTextStyle.color = ScanbotColor('#000000');

  // Start the Document Scanner UI
  var documentResult = await ScanbotSdkUiV2.startDocumentScanner(configuration);
  // Handle the document if the status is 'OK'
  if(documentResult.status == OperationStatus.OK) {
  }
}
