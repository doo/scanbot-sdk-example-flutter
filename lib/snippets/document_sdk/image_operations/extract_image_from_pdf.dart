import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> extractImagesFromPDF(String pdfFileUri) async {
  /**
   * Extract the images from the PDF with the desired configuration options
   * Check if the resulting Page Array is returned
   */
  var imagesResult =
      await ScanbotSdk.pdfImageExtractor.extractImageFiles(pdfFileUri);
}
