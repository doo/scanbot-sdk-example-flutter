import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

DocumentScanningFlow singlePageWithFinderScanningFlow() {
  // Create the default configuration object.
  var configuration = DocumentScanningFlow();

  // Disable the multiple page behavior
  configuration.outputSettings.pagesScanLimit = 1;

  // Enable view finder
  configuration.screens.camera.viewFinder.visible = true;
  configuration.screens.camera.viewFinder.aspectRatio = AspectRatio(width: 3, height: 4);

  // Enable/Disable the review screen.
  configuration.screens.review.enabled = false;

  // Enable/Disable Auto Snapping behavior
  configuration.screens.camera.cameraConfiguration.autoSnappingEnabled = true;

  // Hide the auto snapping enable/disable button
  configuration.screens.camera.bottomBar.autoSnappingModeButton.visible = false;
  configuration.screens.camera.bottomBar.manualSnappingModeButton.visible = false;

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
  var configuration = singlePageWithFinderScanningFlow();
  await ScanbotSdkUiV2.startDocumentScanner(configuration);
}
