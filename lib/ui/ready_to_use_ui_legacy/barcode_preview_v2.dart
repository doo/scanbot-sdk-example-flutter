import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

import 'barcode_item_v2.dart';

class BarcodesResultPreviewWidgetV2 extends StatelessWidget {
  final BarcodeScannerResult preview;

  BarcodesResultPreviewWidgetV2(this.preview);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(),
          leading: GestureDetector(
            child: const Icon(
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
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, position) {
                  return BarcodeItemWidgetV2(preview.items[position]);
                },
                itemCount: preview.items.length,
              ),
            ),
          ],
        ));
  }
}
