import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeCheckOnImage(String uriPath) async {

  // Please show how to use the configurations (at least one prop) in all snippets.
  var configuration = CheckScannerConfiguration();
  configuration.documentDetectionMode = CheckDocumentDetectionMode.DISABLED;

  CheckScanningResult result = await ScanbotSdk.recognizeOperations.recognizeCheckOnImage(uriPath, configuration);
    if (result.status == CheckMagneticInkStripScanningStatus.SUCCESS) {
      //  ...
    }
}

String formatCheckResult(CheckScanningResult result) {
    return "CheckType FullName: ${result.check?.type.fullName}";
}