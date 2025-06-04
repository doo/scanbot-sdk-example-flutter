import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> extractDocumentData(String uriPath) async {
  DocumentDataExtractionResult result = await ScanbotSdk.recognizeOperations.extractDocumentDataFromImage(uriPath, DocumentDataExtractorConfiguration(configurations: []));
    if (result.status == DocumentDataExtractionStatus.SUCCESS) {
      //  ...
    }
}

String formatGenericDocumentResult(DocumentDataExtractionResult result) {
    return "DocumentType: ${result.document?.type.fullName}";
}