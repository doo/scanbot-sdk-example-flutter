import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeGenericDocumentOnImage(String uriPath) async {
    var result = await ScanbotSdkRecognizeOperations.recognizeGenericDocumentOnImage(uriPath);
    if (result.operationResult == OperationResult.SUCCESS) {
      //  ...
    }
}