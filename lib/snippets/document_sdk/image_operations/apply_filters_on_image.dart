import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> applyFiltersOnImage(String imageFileUri) async {
  /** Apply ScanbotBinarizationFilter to the image */
  var imageWithFilters = await ScanbotSdk.imageOperations.applyFiltersOnImage(
    imageFileUri,
    [ScanbotBinarizationFilter()],
  );
  /** Rotate the page counterclockwise by 90 degrees */
  var rotatedImage = await ScanbotSdk.imageOperations.rotateImage(
    imageWithFilters.value!.imageFileUri,
    90,
  );
}