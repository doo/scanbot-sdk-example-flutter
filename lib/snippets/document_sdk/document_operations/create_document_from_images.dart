import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<DocumentData?> createDocumentFromImages(List<ImageRef> images) async {
  final options = CreateDocumentOptions();
  // Configure other parameters (e.g., documentImageSizeLimit) as needed.

  // Run the document creation.
  final result = await ScanbotSdk.document.createDocumentFromImageRefs(
    images: images,
    options: options,
  );

  if (result is Ok<DocumentData>) {
    // Return the created document
    return result.value;
  }
  // Handle the error, e.g. show a message to the user.
  return null;
}
