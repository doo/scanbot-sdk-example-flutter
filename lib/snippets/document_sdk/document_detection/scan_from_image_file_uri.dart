import '../../../utility/utils.dart' show selectImageFromLibrary;

import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> scanDocumentFromImageFileUri() async {
  /**
   * Select an image from the Image Library
   * Return early if no image is selected or there is an issue with selecting an image
   **/
  var imageFile = await selectImageFromLibrary();
  if (imageFile == null) {
    return;
  }
  /** Detect the document */
  var result = await ScanbotSdk.document.scanFromImageFileUri(
    imageFile.path,
    DocumentScannerConfiguration(),
  );
  if (result is Ok<DocumentScanningResult>) {
    /** Handle the result **/
    var documentDetectionResult = result.value;
    // Use the detected polygon, e.g. to crop the image to the document.
  } else {
    // Handle the error, e.g. show a message to the user.
  }
}
