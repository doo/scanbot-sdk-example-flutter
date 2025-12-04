import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> applyFiltersOnImage(String imageFileUri) async {
  /** Apply ScanbotBinarizationFilter to the image */
  var imageWithFilters =
      await ScanbotSdk.imageProcessor.applyFiltersOnImageFile(
    imageFileUri,
    [ScanbotBinarizationFilter()],
  );
  /** Rotate the page counterclockwise by 90 degrees */
  var rotatedImage = await ScanbotSdk.imageProcessor.rotateImageFile(
    imageWithFilters,
    ImageRotation.COUNTERCLOCKWISE_90,
  );
}
