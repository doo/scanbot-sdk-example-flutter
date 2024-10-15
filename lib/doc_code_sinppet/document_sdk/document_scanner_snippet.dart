import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../../utility/utils.dart';

Future<void> runDocumentPageScanner() async {
  var config = DocumentScannerConfiguration(
    bottomBarBackgroundColor: ScanbotRedColor,
    ignoreBadAspectRatio: true,
    multiPageEnabled: true,
    maxNumberOfPages: 3,
    flashEnabled: true,
    autoSnappingSensitivity: 0.7,
    cameraPreviewMode: CameraPreviewMode.FIT_IN,
    orientationLockMode: OrientationLockMode.PORTRAIT,
    documentImageSizeLimit: Size(width: 2000, height: 3000),
    cancelButtonTitle: 'Cancel',
    pageCounterButtonTitle: '%d Page(s)',
    textHintOK: "Perfect, don't move...",
    textHintNothingDetected: "Nothing",
    // ...
  );
  var result = await ScanbotSdkUi.startDocumentScanner(config);

  if (result.operationResult == OperationResult.SUCCESS) {
    // ...
  }
}
