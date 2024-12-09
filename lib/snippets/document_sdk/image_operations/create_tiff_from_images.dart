import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createTIFFFromImages(String imageFileUri) async {
  /** Create a TIFF file with the provided options */
  var params = TIFFFromImagesParams(
      imageFileUris: [imageFileUri],
      options: TiffCreationOptions(
          dpi: 300
      )
  );
  var tiffCreationResult = await ScanbotSdk.imageOperations.createTIFFFromImages(params);
}