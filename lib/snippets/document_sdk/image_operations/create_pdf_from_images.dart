import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createPDFFromImages(String imageFileUri) async {
  /** Create a PDF file with the provided options */
  var params = PDFFromImagesParams(
    imageFileUris: [imageFileUri],
    options: PdfRenderingOptions(
      pageDirection: PageDirection.PORTRAIT,
      pageSize: PageSize.A4,
      ocrConfiguration: OcrOptions(
        engineMode: OcrEngine.SCANBOT_OCR
      )
    )
  );
  var pdfCreationResult = await ScanbotSdk.imageOperations.createPDFForImages(params);
}