import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

import '../../utility/generic_document_helper.dart';

class BarcodeItemWidgetV2 extends StatelessWidget {
  final BarcodeItem item;

  BarcodeItemWidgetV2(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.type?.toString() ?? 'UNKNOWN',
              style: const TextStyle(inherit: true, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(item.text ?? "",
                style: const TextStyle(inherit: true, color: Colors.black)),
          ),
          GenericDocumentHelper.wrappedGenericDocumentField(
              item.parsedDocument),
        ],
      ),
    );
  }
}
