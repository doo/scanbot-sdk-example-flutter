import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeCheckOnImage(String uriPath) async {
    CheckScanResult result = await ScanbotSdkRecognizeOperations.recognizeCheckOnImage(uriPath);
    if (result.operationResult == OperationResult.SUCCESS) {
      //  ...
    }
}

String formatCheckResult(CheckScanResult result) {
    return "CheckType FullName: ${result.check?.type.fullName}";
}