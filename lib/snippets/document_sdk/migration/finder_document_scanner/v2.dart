import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> finderDocumentScanner() async {
  var configuration = DocumentScanningFlow();

  //Equivalent to topBarBackgroundColor: '#ffffff', using palete
  var palette = configuration.palette;
  palette.sbColorPrimary = ScanbotColor('#ffffff');
  palette.sbColorOnPrimary = ScanbotColor('#0027ff');
  // ..

  var cameraScreenConfiguration = configuration.screens.camera;

  var viewFinder = cameraScreenConfiguration.viewFinder;
  viewFinder.visible = true;
  // viewFinder.aspectRatio = AspectRatio(width: 3, height: 4);

  var bottomBar = cameraScreenConfiguration.bottomBar;
  bottomBar.previewButton = NoButtonMode();
  bottomBar.autoSnappingModeButton.visible = false;
  bottomBar.importButton.visible = false;

  cameraScreenConfiguration.acknowledgement.acknowledgementMode = AcknowledgementMode.NONE;
  cameraScreenConfiguration.captureFeedback.snapFeedbackMode = PageSnapFunnelAnimation();

  configuration.screens.review.enabled = false;
  configuration.outputSettings.pagesScanLimit = 1;

  var documentData = await ScanbotSdkUiV2.startDocumentScanner(configuration);
}