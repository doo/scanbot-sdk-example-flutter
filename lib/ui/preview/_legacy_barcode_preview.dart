import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk_example_flutter/ui/pages_widget.dart';

import '../../main.dart';
import '../../utility/generic_document_helper.dart';

class BarcodesResultPreviewWidget extends StatelessWidget {
  final BarcodeScanningResult preview;

  const BarcodesResultPreviewWidget(this.preview, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: <Widget>[
          _buildImageContainer(preview.barcodeImageURI),
          Expanded(
            child: ListView.builder(
              itemCount: preview.barcodeItems.length,
              itemBuilder: (context, index) => BarcodeItemWidget(preview.barcodeItems[index]),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.white,
      title: const Text(
        'Scanned barcodes',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildImageContainer(Uri? imageUri) {
    if (imageUri == null) {
      return const SizedBox();
    }

    final file = File.fromUri(imageUri);
    if (file.existsSync()) {
      return SizedBox(
        height: 200,
        child: shouldInitWithEncryption
            ? EncryptedPageWidget(imageUri)
            : PageWidget(imageUri),
      );
    }
    return const SizedBox();
  }
}


class BarcodeItemWidget extends StatelessWidget {
  final BarcodeItem item;

  const BarcodeItemWidget(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.barcodeFormat?.toString() ?? 'UNKNOWN',
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              item.text ?? '',
              style: const TextStyle(color: Colors.black),
            ),
            GenericDocumentHelper.wrappedGenericDocumentField(item.formattedResult),
          ],
        ),
      ),
    );
  }
}

