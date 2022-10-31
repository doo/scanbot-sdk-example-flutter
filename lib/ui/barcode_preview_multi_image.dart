import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scanbot_sdk/barcode_scanning_data.dart';
import 'package:scanbot_sdk/json/common_data.dart';

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
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height),
          child: ListView.builder(
              itemCount: previewItems.length,
              itemBuilder: (context, positionImages) {
                return Column(children: [
                  const SizedBox(height: 35),
                  getResultTitle(positionImages),
                  const SizedBox(height: 10),
                  getImageContainer(
                      previewItems[positionImages].barcodeImageURI, context),
                  const SizedBox(height: 10),
                  SizedBox(
                      child: getBoldTextWidget("Detected Barcodes"),
                      width: MediaQuery.of(context).size.width - 30),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    //Optional
                    itemCount: previewItems[positionImages].barcodeItems.length,
                    itemBuilder: (context, positionBarcodes) {
                      return getBarcodeDescription(
                          previewItems[positionImages]
                              .barcodeItems[positionBarcodes],
                          context);
                    },
                  ),
                  const SizedBox(height: 10),
                ]);
              }),
        ));
  }

  /// returns the image container widget with mentioned size.
  Widget getImageContainer(Uri? imageUri, BuildContext context) {
    if (imageUri == null) {
      return Container();
    }
    var file = File.fromUri(imageUri);
    var bytes = file.readAsBytesSync();
    final image = Image.memory(bytes, fit: BoxFit.fitWidth);

    return Column(children: [
      Container(
          height: 1,
          color: const Color.fromRGBO(192, 192, 192, 1),
          width: MediaQuery.of(context).size.width - 30),
      const SizedBox(height: 20),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        width: MediaQuery.of(context).size.width - 30,
        child: image,
      )
    ]);
  }

  /// Get the title for each images result.
  Widget getResultTitle(int position) {
    var title = position + 1;

    return SizedBox(
        width: 300,
        child: Text("Result $title",
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontSize: 14.0,
                decorationColor: Color.fromRGBO(192, 192, 192, 1))));
  }

  /// returns the bold text widget
  Widget getBoldTextWidget(String text) {
    return Text(text,
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
  }

  /// get barcode description cell
  Widget getBarcodeDescription(BarcodeItem item, BuildContext context) {
    var widget = SizedBox(
        width: MediaQuery.of(context).size.width - 30,
        child: Row(children: [
          const SizedBox(width: 15),
          getBoldTextWidget(
              barcodeFormatEnumMap[item.barcodeFormat] ?? 'UNKNOWN'),
          const SizedBox(width: 10),
          Text(item.text ?? "", style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 15)
        ]));
    return widget;
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
  BarcodeFormat.MSI_PLESSEY: 'MSI_PLESSEY',
  BarcodeFormat.UNKNOWN: 'UNKNOWN',
};
