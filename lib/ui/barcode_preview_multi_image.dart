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
          constraints: BoxConstraints(maxWidth: MediaQuery
              .of(context)
              .size
              .width, maxHeight: MediaQuery
              .of(context)
              .size
              .height),
          child: ListView.builder(
              // shrinkWrap: true,
              // physics: const ScrollPhysics(),
              itemCount: lstPreviewItems.length,
              itemBuilder: (context, positionImages) {
                return Column(children: [
                  getImageContainer(
                      lstPreviewItems[positionImages].barcodeImageURI),
                  ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery
                          .of(context)
                          .size
                          .width, maxHeight: 70),
                      child:
                      ListView.builder(
                        itemCount: lstPreviewItems[positionImages]
                            .barcodeItems.length,
                        itemBuilder: (context, positionBarcodes) {
                          return Text(lstPreviewItems[positionImages]
                                .barcodeItems[positionBarcodes].text ??
                                "No barcode found.");
                        },
                      )
                  )
                ]);
              }),
        )
    );
  }

  Widget getImageContainer(Uri? imageUri) {
    if (imageUri == null) {
      return Container();
    }
    var file = File.fromUri(imageUri);
    var bytes = file.readAsBytesSync();
    final image = Image.memory(bytes);
    return SizedBox(
      height: 250,
      width: 250,
      child: Center(child: image),
    );
  }
}
