import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createTiffFromImages(List<String> imageFileUris) async {
  /** Create a Tiff file with the provided options */
  var result = await ScanbotSdk.tiffGenerator.generateFromImageFileUris(
    imageFileUris,
    TiffGeneratorParameters(),
  );
  if (result is Ok<String>) {
    /** Handle the tiff */
  } else {
    print(result.toString());
  }
}
