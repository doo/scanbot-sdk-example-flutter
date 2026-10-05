import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> applyFiltersOnImage(String imageFileUri) async {
  /** Apply ScanbotBinarizationFilter to the image */
  var imageWithFiltersResult = await ScanbotSdk.imageProcessor
      .applyFiltersOnImageFile(imageFileUri, [ScanbotBinarizationFilter()]);

  if (imageWithFiltersResult is Ok<String>) {
    /** Rotate the page counterclockwise by 90 degrees */
    var rotatedImageResult = await ScanbotSdk.imageProcessor.rotateImageFile(
      imageWithFiltersResult.value,
      ImageRotation.COUNTERCLOCKWISE_90,
    );

    if (rotatedImageResult is Ok<String>) {
      /** Handle the rotated image, e.g. display it or save it to the gallery */
    } else {
      // Handle the error, e.g. show a message to the user.
    }
  }
}
