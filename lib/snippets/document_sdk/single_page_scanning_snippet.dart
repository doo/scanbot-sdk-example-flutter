import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

DocumentScanningFlow singlePageScanningFlow() {
  // Create the default configuration object.
  var configuration = DocumentScanningFlow();

  // Disable the multiple page behavior
  configuration.outputSettings.pagesScanLimit = 1;
  // Enable/Disable the review screen.
  configuration.screens.review.enabled = false;
  // Enable/Disable Auto Snapping behavior
  configuration.screens.camera.cameraConfiguration.autoSnappingEnabled = true;

  /**
   * Configure the animation
   * You can choose between genie animation or checkmark animation
   * Note: Both modes can be further configured to your liking
   * e.g for genie animation
   */
  configuration.screens.camera.captureFeedback.snapFeedbackMode = PageSnapFunnelAnimation();
  // or for checkmark animation
  configuration.screens.camera.captureFeedback.snapFeedbackMode = PageSnapCheckMarkAnimation();

  // Hide the auto snapping enable/disable button
  configuration.screens.camera.bottomBar.autoSnappingModeButton.visible = false;
  configuration.screens.camera.bottomBar.manualSnappingModeButton.visible = false;
  configuration.screens.camera.bottomBar.importButton.title.visible = true;
  configuration.screens.camera.bottomBar.torchOnButton.title.visible = true;
  configuration.screens.camera.bottomBar.torchOffButton.title.visible = true;

  // Set colors
  configuration.palette.sbColorPrimary = ScanbotColor("#C8193CFF");
  configuration.palette.sbColorOnPrimary = ScanbotColor('#ffffff');

  // Configure the hint texts for different scenarios
  configuration.screens.camera.userGuidance.statesTitles.tooDark = 'Need more lighting to detect a document';
  configuration.screens.camera.userGuidance.statesTitles.tooSmall = 'Document too small';
  configuration.screens.camera.userGuidance.statesTitles.noDocumentFound = 'Could not detect a document';

  return configuration;
}

void runDocumentScanner() async {
  var configuration = singlePageScanningFlow();
  await ScanbotSdkUi.startDocumentScanner(configuration);
}
