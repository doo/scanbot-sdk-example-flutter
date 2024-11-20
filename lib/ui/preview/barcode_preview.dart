import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

import '../../utility/generic_document_helper.dart';

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


class BarcodeItemWidgetV2 extends StatelessWidget {
  final BarcodeItem item;

  const BarcodeItemWidgetV2(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.type?.toString() ?? 'UNKNOWN',
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              item.text ?? '',
              style: const TextStyle(color: Colors.black),
            ),
            GenericDocumentHelper.wrappedGenericDocumentField(item.parsedDocument),
          ],
        ),
      ),
    );
  }
}