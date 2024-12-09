import '../../../utility/utils.dart' show selectImageFromLibrary;
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> detectDocumentDetection() async {
  /**
   * Select an image from the Image Library
   * Return early if no image is selected or there is an issue with selecting an image
   **/
  var imageFile = await selectImageFromLibrary();
  if (imageFile == null) {
    return;
  }
  /** Detect the document */
  var documentDetectionResult = await ScanbotSdk.document.detectDocument(imageFile.path);
}