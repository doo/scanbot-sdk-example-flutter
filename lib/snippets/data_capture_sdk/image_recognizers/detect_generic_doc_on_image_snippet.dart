import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeGenericDocumentOnImage(String uriPath) async {
    GenericDocumentRecognizerResult result = await ScanbotSdkRecognizeOperations.recognizeGenericDocumentOnImage(uriPath);
    if (result.operationResult == OperationResult.SUCCESS && result.status == GenericDocumentRecognitionStatus.Success) {
      //  ...
    }
}

String formatGenericDocumentResult(GenericDocumentRecognizerResult result) {
    return "DocumentType: ${result.document?.type.fullName}";
}