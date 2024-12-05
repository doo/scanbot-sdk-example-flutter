import 'package:scanbot_sdk/scanbot_sdk.dart';

FinderDocumentScannerConfiguration finderDocumentConfigurationSnippet() {
  return FinderDocumentScannerConfiguration(
    ignoreBadAspectRatio: true,
    // allow only documents with at least 75% of finder to be scanned
    acceptedSizeScore: 0.75,
    //maxNumberOfPages: 3,
    //flashEnabled: true,
    //autoSnappingSensitivity: 0.7,
    cameraPreviewMode: CameraPreviewMode.FIT_IN,
    orientationLockMode: OrientationLockMode.PORTRAIT,
    //documentImageSizeLimit: Size(2000, 3000),
    cancelButtonTitle: 'Cancel',
    textHintOK: "Perfect, don't move...",
    //textHintNothingDetected: "Nothing",
    // ...
  );
}