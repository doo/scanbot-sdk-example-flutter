import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk_example_flutter/utility/utils.dart';

Future<void> performOCR() async {
  /**
   * Select an image from the Image Library
   * Return early if no image is selected or there is an issue with selecting an image
   **/
  final file = await selectImageFromLibrary();
  if (file == null || file.path.isEmpty) return;

  var result = await ScanbotSdk.ocrEngine.recognizeOnImageFileUris([file.path]);

  if (result is Ok<PerformOcrResult>) {
    // Handle the result, e.g. display result.value.recognizedText to the user.
  } else {
    // Handle the error, e.g. show a message to the user.
  }
}
