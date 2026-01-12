import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createDocumentFromPDF(String pdfFilePath) async {
  /**
   * Create a document with a uuid
   * Extract images from the PDF file and add them as document pages
   */
  var documentResult =
      await ScanbotSdk.document.createDocumentFromPdf(pdfFilePath);
  if (documentResult is Ok<DocumentData>) {
    /** Handle the document */
  }
}
