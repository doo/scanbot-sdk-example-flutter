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
    print(documentData);
  } else {
    print(documentResult.toString());
  }
}
