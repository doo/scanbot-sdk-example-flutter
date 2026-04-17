import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createDocumentPDF() async {
  /** Load a document from storage or create a new one */
  var documentResult = await ScanbotSdk.document.loadDocument(
    'SOME_STORED_DOCUMENT_ID',
  );
  /** Create a PDF file with the provided options */
  var pdfConfiguration = PdfConfiguration(
    pageSize: PageSize.A4,
    pageDirection: PageDirection.PORTRAIT,
  );

  if (documentResult is Ok<DocumentData>) {
    var ocrConfiguration = OcrConfiguration(engineMode: OcrEngine.SCANBOT_OCR);
    var pdfUriResult = await ScanbotSdk.pdfGenerator.generateFromDocument(
      documentResult.value.uuid,
      pdfConfiguration,
      ocrConfiguration: ocrConfiguration,
    );
    if (pdfUriResult is Ok<String>) {
      /** Handle the pdf */
    }
  } else {
    print(documentResult.toString());
  }
}
