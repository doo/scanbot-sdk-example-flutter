import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeCheckOnImage(String uriPath) async {
  var configuration = CheckScannerConfiguration();
  configuration.documentDetectionMode = CheckDocumentDetectionMode.DETECT_DOCUMENT;
  // Configure other parameters as needed.

  CheckScanningResult result = await ScanbotSdk.check.scanFromImageFileUri(uriPath, configuration);
  if (result.status == CheckMagneticInkStripScanningStatus.SUCCESS) {
    //  ...
  }
}

String formatCheckResult(CheckScanningResult result) {
    return "CheckType FullName: ${result.check?.type.fullName}";
}