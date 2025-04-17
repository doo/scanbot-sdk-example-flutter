import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../../utility/generic_document_helper.dart';
import '../../utility/utils.dart';

class BarcodesResultPreviewWidget extends StatelessWidget {
  final List<BarcodeItem> previewItems;

  const BarcodesResultPreviewWidget(this.previewItems, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScanbotAppBar('Scanned barcodes', showBackButton: true, context: context),
      body: ListView.builder(
        itemCount: previewItems.length,
        itemBuilder: (context, imageIndex) {
          final result = previewItems[imageIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const material.EdgeInsets.all(15),
                child: Text('Result ${imageIndex + 1}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              BarcodeCard(
                sourceImage: result.sourceImage?.buffer != null ? Image.memory(result.sourceImage!.buffer!) : null,
                format: result.format.name,
                text: result.text,
                extraWidget: GenericDocumentHelper.wrappedGenericDocumentField(result.extractedDocument),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BarcodeCard extends StatelessWidget {
  final String format;
  final String text;
  final Widget? extraWidget;
  final Image? sourceImage;

  const BarcodeCard({
    required this.format,
    required this.text,
    this.extraWidget,
    this.sourceImage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: sourceImage),
            Text(format, style: const TextStyle(color: Colors.black)),
            Text(text, style: const TextStyle(color: Colors.black)),
            if (extraWidget != null) extraWidget!,
          ],
        ),
      ),
    );
  }
}