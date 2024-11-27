import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

DocumentScanningFlow localizationConfigurationFlowSnippet() {
  return DocumentScanningFlow()
  // Configure the strings.
  ..localization.cameraTopBarTitle = "document.camera.title"
  ..localization.reviewScreenSubmitButtonTitle = "review.submit.title"
  ..localization.cameraUserGuidanceNoDocumentFound = "camera.userGuidance.noDocumentFound"
  ..localization.cameraUserGuidanceTooDark = "camera.userGuidance.tooDark";
}

void runDocumentScanner() async {
  var configuration = localizationConfigurationFlowSnippet();
  await ScanbotSdkUi.startDocumentScanner(configuration);
}