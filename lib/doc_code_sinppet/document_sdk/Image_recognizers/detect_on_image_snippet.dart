import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> detectDocumentOnImage(String uriPath) async {
    var result = await ScanbotSdkRecognizeOperations.recognizeMrzOnImage(uriPath);
    if (result.operationResult == OperationResult.SUCCESS) {
      //  ...
    }
}