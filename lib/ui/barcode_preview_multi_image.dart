import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/barcode_scanning_data.dart';
import 'package:scanbot_sdk_example_flutter/ui/pages_widget.dart';

import '../main.dart';
import 'barcode_preview.dart';

class MultiImageBarcodesResultPreviewWidget extends StatelessWidget {
  final List<BarcodeScanningResult> lstPreviewItems;

  MultiImageBarcodesResultPreviewWidget(this.lstPreviewItems);

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
      body: ConstrainedBox(
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
    child: ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: lstPreviewItems.length,
          itemBuilder: (context, positionImages) {
            return SizedBox(
              height: 200,
              width: 200,
              child: Row(children: [
                getImageContainer(
                    lstPreviewItems[positionImages].barcodeImageURI),
                   ListView.builder(
                     itemBuilder: (context, positionBarcodes) {
                       return Text(lstPreviewItems[positionImages].barcodeItems[positionBarcodes].text ?? "No barcode found.");
                     },
                     itemCount:
                         lstPreviewItems[positionImages].barcodeItems.length,
                   )
              ]),
            );
          }),
      )
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
