import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk_example_flutter/utility/utils.dart';

Future<void> straightenImage() async {
  final selectedImage = await selectImageFromLibrary();
  if (selectedImage == null || selectedImage.path.isEmpty) return;

  await autorelease(() async {
    final straighteningParameters = DocumentStraighteningParameters()
      // Configure the straightening mode as needed
      ..straighteningMode = DocumentStraighteningMode.STRAIGHTEN

      // The straightening parameters can be customized to fit the expected aspect ratio of the document to be straightened.
      // This can help the straightening algorithm to achieve better results.
      ..aspectRatios = [
        AspectRatio(width: 5, height: 7),
        AspectRatio(width: 1, height: 1),
        AspectRatio(width: 16, height: 9),
        AspectRatio(width: 3, height: 4),
      ];

    final result = await ScanbotSdk.documentEnhancer.straightenImageFileUri(
      selectedImage.path,
      straighteningParameters,
    );

    if (result is Ok<DocumentStraighteningResult>) {
      // Handle the document straightening result
      final encodedImage = result.value.straightenedImage?.encodeImage();
    } else {
      print(result.toString());
    }
  });
}
