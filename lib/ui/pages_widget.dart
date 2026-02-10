import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

class PageWidget extends StatelessWidget {
  final String path;

  PageWidget(this.path);

  @override
  Widget build(BuildContext context) {
    var file = File(Uri.parse(path).toFilePath());
    var bytes = file.readAsBytesSync();
    final image = Image.memory(bytes);
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(child: image),
    );
  }
}

class EncryptedPageWidget extends StatelessWidget {
  final String path;

  EncryptedPageWidget(this.path);

  @override
  Widget build(BuildContext context) {
    final imageDataFuture = ScanbotSdk.imageProcessor.readImageData(path);
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: FutureBuilder<Result<String>>(
        future: imageDataFuture,
        builder:
            (BuildContext context, AsyncSnapshot<Result<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(strokeWidth: 10),
              ),
            );
          }

          var result = snapshot.data;
          if (result is Ok<String>) {
            Uint8List bytes = base64Decode(
              result.value.replaceAll(RegExp(r'\s+'), ''),
            );
            final image = Image.memory(bytes);
            return Center(child: image);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
