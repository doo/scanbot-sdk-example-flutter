import 'package:scanbot_sdk/scanbot_sdk.dart';

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
  var documentResult = await ScanbotSdk.document.startScanner(configuration);
  // Handle the document if the result is 'Ok'
  if (documentResult is Ok<DocumentData>) {
    var documentData = documentResult.value;
    print(documentData);
  } else {
    print(documentResult.toString());
  }
}
