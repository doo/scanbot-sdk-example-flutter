import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeCheckOnImage(String uriPath) async {
  var configuration = CheckScannerConfiguration();
  configuration.documentDetectionMode =
      CheckDocumentDetectionMode.DETECT_DOCUMENT;
  // Configure other parameters as needed.

  var result = await ScanbotSdk.check.scanFromImageFileUri(
    uriPath,
    configuration,
  );
  if (result is Ok<CheckScanningResult> &&
      result.value.status == CheckMagneticInkStripScanningStatus.SUCCESS) {
    /** Handle the result **/
  } else {
    print(result.toString());
  }
}

String formatCheckResult(CheckScanningResult result) {
  return "CheckType FullName: ${result.check?.type.fullName}";
}
