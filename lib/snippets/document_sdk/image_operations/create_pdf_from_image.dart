import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createPdfFromImages(List<String> imageFileUris) async {
  var params = CreatePDFArguments(
      imageFileUris: imageFileUris,
      pdfConfiguration: PdfConfiguration(),
  );

  /** Create a PDF file with the provided options */
  var result = await ScanbotSdk.imageOperations.createPDFFromImages(params);
}