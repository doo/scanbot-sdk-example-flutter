import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeCheckOnImage(String uriPath) async {
    var result = await ScanbotSdkRecognizeOperations.recognizeCheckOnImage(uriPath);
    if (result.operationResult == OperationResult.SUCCESS) {
      //  ...
    }
}