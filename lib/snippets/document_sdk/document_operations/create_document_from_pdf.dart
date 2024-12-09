import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createDocumentFromPDF(Uri pdfUri) async {
  /**
   * Create a document with an uuid
   * Extract images from the PDF file and add them as document pages
   */
  var document = await ScanbotSdk.document.createDocumentFromPDF(pdfUri);
}