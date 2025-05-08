import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createTiffFromImages(List<String> imageFileUris) async {
  var params = WriteTIFFArguments(
      imageFileUris: imageFileUris,
      configuration: TiffGeneratorParameters()
  );

  /** Create a Tiff file with the provided options */
  var result = await ScanbotSdk.imageOperations.createTIFFFromImages(params);
}