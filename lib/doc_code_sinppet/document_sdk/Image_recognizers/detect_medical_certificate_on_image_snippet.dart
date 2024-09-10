import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeMedicalDocumentOnImage(String uriPath) async {
    var result = await ScanbotSdkRecognizeOperations.recognizeMedicalCertificateOnImage(uriPath);
    if (result.operationResult == OperationResult.SUCCESS) {
      //  ...
    }
}