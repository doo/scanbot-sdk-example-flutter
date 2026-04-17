import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createPdfFromImages(List<String> imageFileUris) async {
  /** Create a PDF file with the provided options */
  var result = await ScanbotSdk.pdfGenerator.generateFromImageFileUris(
    imageFileUris,
    PdfConfiguration(),
    ocrConfiguration: OcrConfiguration(engineMode: OcrEngine.SCANBOT_OCR),
  );
  if (result is Ok<String>) {
    /** Handle the pdf */
  } else {
    print(result.toString());
  }
}
