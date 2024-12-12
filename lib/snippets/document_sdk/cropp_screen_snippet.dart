import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

void startCropping() async {
  // Create the default configuration object.
  var configuration = DocumentScanningFlow();

  // Retrieve the instance of the crop configuration from the main configuration object.
  var cropScreenConfiguration = configuration.screens.cropping;
  // Disable the rotation feature.
  cropScreenConfiguration.bottomBar.rotateButton.visible = false;
  // Configure various colors.
  configuration.appearance.topBarBackgroundColor = ScanbotColor('#C8193C');
  cropScreenConfiguration.topBarConfirmButton.foreground.color = ScanbotColor('#FFFFFF');
  // Customize a UI element's text
  configuration.localization.croppingTopBarCancelButtonTitle = 'Cancel';
  // Start the Document Scanner UI
  var documentResult = await ScanbotSdkUiV2.startDocumentScanner(configuration);
  // Handle the document if the status is 'OK'
  if(documentResult.status == OperationStatus.OK) {
  }
}
