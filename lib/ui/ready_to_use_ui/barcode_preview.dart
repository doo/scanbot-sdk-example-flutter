import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk_example_flutter/ui/pages_widget.dart';

import '../../main.dart';
import 'barcode_item.dart';

class BarcodesResultPreviewWidget extends StatelessWidget {
  final BarcodeScanningResult preview;

  BarcodesResultPreviewWidget(this.preview);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Scanned barcodes',
          style: TextStyle(
            inherit: true,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          getImageContainer(preview.barcodeImageURI),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, position) {
                return BarcodeItemWidget(preview.barcodeItems[position]);
              },
              itemCount: preview.barcodeItems.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget getImageContainer(Uri? imageUri) {
    if (imageUri == null) {
      return Container();
    }

    var file = File.fromUri(imageUri);
    if (file.existsSync() == true) {
      if (shouldInitWithEncryption) {
        return SizedBox(
          height: 200,
          child: EncryptedPageWidget(imageUri),
        );
      } else {
        return SizedBox(
          height: 200,
          child: PageWidget(imageUri),
        );
      }
    }
    return Container();
  }
}
