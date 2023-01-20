import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_encryption_handler.dart';

class PageWidget extends StatelessWidget {
  final Uri path;

  PageWidget(this.path);

  @override
  Widget build(BuildContext context) {
    var file = File.fromUri(path);
    var bytes = file.readAsBytesSync();
    //should be this one after fixing https://github.com/flutter/flutter/issues/17419
    //
    // var image = Image.file(
    //    file,
    //   height: double.infinity,
    //    width: double.infinity,
    // );
    final image = Image.memory(bytes);
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(child: image),
    );
  }
}

class EncryptedPageWidget extends StatelessWidget {
  final Uri path;

  EncryptedPageWidget(this.path);

  @override
  Widget build(BuildContext context) {
    //var file = File.fromUri(path);
    // var bytes = file.readAsBytesSync();
    //should be this one after fixing https://github.com/flutter/flutter/issues/17419
    //
    // var image = Image.file(
    //    file,
    //   height: double.infinity,
    //    width: double.infinity,
    // );
    final imageData = ScanbotEncryptionHandler.getDecryptedDataFromFile(path);
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: FutureBuilder<Uint8List>(
        future: imageData,
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                strokeWidth: 10,
              ),
            ));
          }
          if (snapshot.data != null) {
            final image = Image.memory(snapshot.data!);
            return Center(child: image);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
