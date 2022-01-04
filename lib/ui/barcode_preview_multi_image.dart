import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scanbot_sdk/barcode_scanning_data.dart';

class MultiImageBarcodesResultPreviewWidget extends StatelessWidget {
  final List<BarcodeScanningResult> previewItems;

  /// constructor
  MultiImageBarcodesResultPreviewWidget(this.previewItems);

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
              itemCount: previewItems.length,
              itemBuilder: (context, positionImages) {
                return Column(children: [
                  getImageContainer(
                      previewItems[positionImages].barcodeImageURI),
                  ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery
                          .of(context)
                          .size
                          .width, maxHeight: 70),
                      child:
                      ListView.builder(
                        itemCount: previewItems[positionImages]
                            .barcodeItems.length,
                        itemBuilder: (context, positionBarcodes) {
                          return Padding(padding: const EdgeInsets.all(5), child: Text(previewItems[positionImages]
                                .barcodeItems[positionBarcodes].text ??
                                "No barcode found.", textAlign: TextAlign.center));
                        },
                      )
                  )
                ]);
              }),
        )
    );
  }

  /// returns the image container widget with mentioned size.
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
