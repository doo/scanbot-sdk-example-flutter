import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createDocumentTIFF() async {
  /** Load a document from storage or create a new one */
  var document = await ScanbotSdk.document.loadDocument(
    'SOME_STORED_DOCUMENT_ID',
  );
  /** Create a TIFF file with the provided options */
  var params = TIFFFromDocumentParams(
    documentID: document.uuid,
    configuration: TiffGeneratorParameters()
  );
  var tiffUriResult = await ScanbotSdk.document.createTIFFForDocument(params);
}