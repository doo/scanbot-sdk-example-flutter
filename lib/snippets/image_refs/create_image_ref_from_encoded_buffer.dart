import 'dart:math';
import 'dart:typed_data';
import 'package:scanbot_sdk/scanbot_sdk.dart';

void createImageRefFromEncodedBuffer(Uint8List bytes) {
  autorelease(() {
    // Create ImageRef from buffer
    var imageRef = ImageRef.fromEncodedBuffer(bytes);

    // Create ImageRef from buffer with options
    var imageRefWithOptions = ImageRef.fromEncodedBuffer(
      bytes,
      options: BufferImageLoadOptions(
          // Define crop rectangle
          cropRect: const Rectangle<int>(0, 0, 200, 200),
          // Convert image to grayscale
          colorConversion: ColorConversion.GRAY,
          // Use lazy loading mode, image would be loaded into memory only when first used
          loadMode: BufferLoadMode.LAZY),
    );
  });
}
