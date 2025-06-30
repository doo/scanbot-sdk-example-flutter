import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> documentScanner() async {
  var configuration = DocumentScanningFlow();

  var cameraScreenConfiguration = configuration.screens.camera;

  // Equivalent to autoSnappingSensitivity: 0.67
  cameraScreenConfiguration.cameraConfiguration.autoSnappingSensitivity = 0.67;

  // Ready-to-Use UI v2 contains an acknowledgment screen to
  // verify the captured document with the built-in Document Quality Analyzer.
  // You can still disable this step:
  cameraScreenConfiguration.acknowledgement.acknowledgementMode = AcknowledgementMode.NONE;

  // When you disable the acknowledgment screen, you can enable the capture feedback,
  // there are different options available, for example you can display a checkmark animation:
  cameraScreenConfiguration.captureFeedback.snapFeedbackMode = PageSnapFunnelAnimation();

  // You may hide the import button in the camera screen, if you don't need it:
  cameraScreenConfiguration.bottomBar.importButton.visible = false;

  // Equivalent to bottomBarBackgroundColor: '#ffffff', but not recommended:
  configuration.appearance.bottomBarBackgroundColor = ScanbotColor('#ffffff');

  // However, now all the colors can be conveniently set using the Palette object:
  var palette = configuration.palette;
  palette.sbColorPrimary = ScanbotColor('#ffffff');
  palette.sbColorOnPrimary = ScanbotColor('#ffffff');
  // ..

  // Now all the text resources are in the localization object
  var localization = configuration.localization;
  // Equivalent to textHintOK: "Don't move.\nCapturing document...",
  localization.cameraUserGuidanceReadyToCapture =
  "Don't move. Capturing document...";

  // Ready-to-Use UI v2 contains a review screen, you can disable it:
  configuration.screens.review.enabled = false;

  // Multi Page button is always hidden in RTU v2
  // Therefore multiPageButtonHidden: true is not available

  // Equivalent to multiPageEnabled: false
  configuration.outputSettings.pagesScanLimit = 1;

  var documentData = await ScanbotSdkUiV2.startDocumentScanner(configuration);
}