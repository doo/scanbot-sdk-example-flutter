import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/barcode_scanning_data.dart';

class BarcodesResultPreviewWidget extends StatelessWidget {
  final BarcodeScanningResult preview;

  BarcodesResultPreviewWidget(this.preview);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(),
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          title: const Text('Scanned barcodes',
              style: TextStyle(inherit: true, color: Colors.black)),
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
        ));
  }

  Widget getImageContainer(Uri? imageUri) {
    if (preview.barcodeImageURI == null) {
      return Container();
    }
    var file = File.fromUri(imageUri!);
    if (file.existsSync() == true) {
      return Container(
          child: Center(
        child: Image.file(
          file,
          height: 200,
          width: double.infinity,
        ),
      ));
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
              barcodeFormatEnumMap[item.barcodeFormat] ?? "UNKNOWN",
              style: TextStyle(inherit: true, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(item.text ?? "",
                style: TextStyle(inherit: true, color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

const barcodeFormatEnumMap = {
  BarcodeFormat.AZTEC: 'AZTEC',
  BarcodeFormat.CODABAR: 'CODABAR',
  BarcodeFormat.CODE_39: 'CODE_39',
  BarcodeFormat.CODE_93: 'CODE_93',
  BarcodeFormat.CODE_128: 'CODE_128',
  BarcodeFormat.DATA_MATRIX: 'DATA_MATRIX',
  BarcodeFormat.EAN_8: 'EAN_8',
  BarcodeFormat.EAN_13: 'EAN_13',
  BarcodeFormat.ITF: 'ITF',
  BarcodeFormat.PDF_417: 'PDF_417',
  BarcodeFormat.QR_CODE: 'QR_CODE',
  BarcodeFormat.RSS_14: 'RSS_14',
  BarcodeFormat.RSS_EXPANDED: 'RSS_EXPANDED',
  BarcodeFormat.UPC_A: 'UPC_A',
  BarcodeFormat.UPC_E: 'UPC_E',
  BarcodeFormat.UNKNOWN: 'UNKNOWN',
};
