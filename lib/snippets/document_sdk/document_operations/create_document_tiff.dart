import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createDocumentTIFF() async {
  /** Load a document from storage or create a new one */
  var documentResult = await ScanbotSdk.document.loadDocument(
    'SOME_STORED_DOCUMENT_ID',
  );
  if (documentResult is Ok<DocumentData>) {
    /** Create a TIFF file with the provided options */
    var tiffUriResult = await ScanbotSdk.tiffGenerator.generateFromDocument(
        documentResult.value.uuid, TiffGeneratorParameters());
    if (tiffUriResult is Ok<String>) {
      /** Handle the document */
    }
  }
}
