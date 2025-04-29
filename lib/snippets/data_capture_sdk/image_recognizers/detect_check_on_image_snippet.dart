import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeCheckOnImage(String uriPath) async {
  CheckScanningResult result = await ScanbotSdk.recognizeOperations.recognizeCheckOnImage(uriPath, CheckScannerConfiguration());
    if (result.status == CheckMagneticInkStripScanningStatus.SUCCESS) {
      //  ...
    }
}

String formatCheckResult(CheckScanningResult result) {
    return "CheckType FullName: ${result.check?.type.fullName}";
}