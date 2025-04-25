import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeGenericDocumentOnImage(String uriPath) async {
  DocumentDataExtractionResult result = await ScanbotSdk.recognizeOperations.recognizeGenericDocumentOnImage(uriPath);
    if (result.status == DocumentDataExtractionStatus.SUCCESS) {
      //  ...
    }
}

String formatGenericDocumentResult(DocumentDataExtractionResult result) {
    return "DocumentType: ${result.document?.type.fullName}";
}