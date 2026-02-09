import 'dart:math';
import 'package:scanbot_sdk/scanbot_sdk.dart';

void createImageRefFromPath(String imagePath) {
  autorelease(() {
    // Create ImageRef from path
    var imageRef = ImageRef.fromPath(imagePath);

    // Create ImageRef from  path with options
    var imageRefWithOptions = ImageRef.fromPath(
      imagePath,
      options: PathImageLoadOptions(
        // Define crop rectangle
        cropRect: const Rectangle<int>(0, 0, 200, 200),
        // Convert image to grayscale
        colorConversion: ColorConversion.GRAY,
        // Use lazy loading mode, image would be loaded into memory only when first used
        loadMode: PathLoadMode.LAZY_WITH_COPY,
        // handle encryption automatically based on global ImageRef/ScanbotSdk encryption settings
        encryptionMode: EncryptionMode.AUTO,
        // to disable decryption while reading for this specific file (in case its not encrypted with SDK encryption ON), use
        // encryptionMode: EncryptionMode.DISABLED,
      ),
    );
  });
}
