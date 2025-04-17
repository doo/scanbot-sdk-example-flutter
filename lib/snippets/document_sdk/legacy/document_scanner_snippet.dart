import 'package:flutter/material.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';

DocumentScannerConfiguration documentConfigurationSnippet() {
  return DocumentScannerConfiguration(
    bottomBarBackgroundColor: const Color(0xFFc8193c),
    ignoreOrientationMismatch: true,
    multiPageEnabled: true,
    maxNumberOfPages: 3,
    autoSnappingSensitivity: 0.7,
    cameraPreviewMode: CameraPreviewMode.FIT_IN,
    orientationLockMode: OrientationLockMode.PORTRAIT,
    documentImageSizeLimit: Size(width: 2000, height: 3000),
    cancelButtonTitle: 'Cancel',
    pageCounterButtonTitle: '%d Page(s)',
    textHintOK: "Perfect, don't move...",
    textHintNothingDetected: "Nothing",
  );
}