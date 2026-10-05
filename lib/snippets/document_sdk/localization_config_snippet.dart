import 'package:scanbot_sdk/scanbot_sdk.dart';

DocumentScanningFlow localizationConfigurationFlowSnippet() {
  return DocumentScanningFlow()
    // Configure the strings.
    ..localization.cameraTopBarTitle = "document.camera.title"
    ..localization.reviewScreenSubmitButtonTitle = "review.submit.title"
    ..localization.cameraUserGuidanceNoDocumentFound =
        "camera.userGuidance.noDocumentFound"
    ..localization.cameraUserGuidanceTooDark = "camera.userGuidance.tooDark";
}

void runDocumentScanner() async {
  var configuration = localizationConfigurationFlowSnippet();
  var documentResult = await ScanbotSdk.document.startScanner(configuration);
  // Handle the document if the result is 'Ok'
  if (documentResult is Ok<DocumentData>) {
    var documentData = documentResult.value;
    // Display the scanned pages, or export the document as PDF/TIFF.
  } else {
    // Handle the error or cancellation, e.g. show a message to the user.
  }
}
