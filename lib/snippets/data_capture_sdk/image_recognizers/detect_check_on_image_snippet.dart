import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeCheckOnImage(String uriPath) async {
  CheckScanningResult result = await ScanbotSdkRecognizeOperations.recognizeCheckOnImage(uriPath);
    if (result.status == CheckMagneticInkStripScanningStatus.SUCCESS) {
      //  ...
    }
}

String formatCheckResult(CheckScanningResult result) {
    return "CheckType FullName: ${result.check?.type.fullName}";
}