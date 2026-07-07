import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:scanbot_sdk_example_flutter/utility/utils.dart';

class ImagePreview extends StatelessWidget {
  final Uint8List imageBytes;

  const ImagePreview({
    super.key,
    required this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScanbotAppBar('Image Preview'),
      body: Center(
        child: Image.memory(
          imageBytes,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('Failed to load image'),
              ],
            );
          },
        ),
      ),
    );
  }
}
