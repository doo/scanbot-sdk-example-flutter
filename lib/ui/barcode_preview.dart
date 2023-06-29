import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/barcode_scanning_data.dart';
import 'package:scanbot_sdk/json/common_data.dart';
import 'package:scanbot_sdk/json/common_platform.dart';
import 'package:scanbot_sdk_example_flutter/ui/pages_widget.dart';
import 'package:scanbot_sdk_example_flutter/utility/barcode_helper.dart';

import '../main.dart';

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

class BarcodeItemWidget extends StatelessWidget {
  final BarcodeItem item;

  BarcodeItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
             BarcodeHelper.barcodeFormatEnumMap[item.barcodeFormat] ?? 'UNKNOWN',
              style: const TextStyle(
                inherit: true,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.text ?? '',
              style: const TextStyle(
                inherit: true,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}