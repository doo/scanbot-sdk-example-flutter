import 'package:flutter/material.dart';
import 'package:scanbot_sdk/json/common_generic_document.dart';
import 'package:scanbot_sdk/json/generic_document_wrappers.dart';
import 'package:scanbot_sdk/mrz_scanning_data.dart';

import 'generic_document_preview.dart';

class MrzDocumentResultPreview extends StatefulWidget {
  final MrzScanningResult? result;

  MrzDocumentResultPreview(
    this.result,
  );

  @override
  State<MrzDocumentResultPreview> createState() =>
      _MrzDocumentResultPreviewState();
}

class _MrzDocumentResultPreviewState
    extends State<MrzDocumentResultPreview> {
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
            'Mrz Result',
            style: TextStyle(
              inherit: true,
              color: Colors.black,
            ),
          ),
        ),
        body: widget.result?.document != null
            ? MrzView(widget.result!.document!)
            : Container());
  }
}
