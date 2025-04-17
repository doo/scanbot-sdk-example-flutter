import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

import '../../utility/utils.dart';
import 'generic_document_preview.dart';

class MrzDocumentResultPreview extends StatefulWidget {
  final MrzScannerUiResult result;

  MrzDocumentResultPreview(
    this.result,
  );

  @override
  State<MrzDocumentResultPreview> createState() =>
      _MrzDocumentResultPreviewState();
}

class _MrzDocumentResultPreviewState extends State<MrzDocumentResultPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ScanbotAppBar('Mrz Result', showBackButton: true, context: context),
        body: widget.result.mrzDocument != null
            ? MrzView(MRZ(widget.result.mrzDocument!))
            : Container());
  }
}
