import 'package:scanbot_sdk/core.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createDocumentPDF() async {
  /** Load a document from storage or create a new one */
  var document = await ScanbotSdk.document.loadDocument(
    'SOME_STORED_DOCUMENT_ID',
  );
  /** Create a PDF file with the provided options */
  var params = PDFFromDocumentParams(
    documentID: document.uuid,
      pdfConfiguration: PdfConfiguration(
      pageSize: PageSize.A4,
      pageDirection: PageDirection.PORTRAIT,
    ),
    ocrConfiguration: OcrOptions(
        engineMode: OcrEngine.SCANBOT_OCR
    )
  );
  var pdfUriResult = await ScanbotSdk.document.createPDFForDocument(params);
}
