import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> _recognizeDocumentOnImage(String uriPath) async {
    var result = await ScanbotSdkRecognizeOperations.recognizeHealthInsuranceCardOnImage(uriPath);
    if (result.operationResult == OperationResult.SUCCESS) {
      //  ...
    }
}