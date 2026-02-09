import 'package:scanbot_sdk/scanbot_sdk.dart';

void saveImage(ImageRef imageRef, String destinationPath) {
  imageRef.saveImage(
    destinationPath,
    options: SaveImageOptions(
      quality: 100, encryptionMode: EncryptionMode.AUTO,
      // to disable decryption while saving this specific file, use
      // encryptionMode: EncryptionMode.DISABLED,
    ),
  );

  // Returns the stored image as a byte array.
  final byteArray = imageRef.encodeImage();
}
