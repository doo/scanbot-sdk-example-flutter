import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../ui/menu_item_widget.dart';
import '../ui/preview/barcode_multi_images_preview.dart';
import '../ui/preview/_legacy_barcode_preview.dart';
import '../utility/utils.dart';

import 'barcode_use_cases.dart';
import '_legacy_barcode_use_cases.dart';

class BarcodeSdkMenu extends StatelessWidget {
  const BarcodeSdkMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScanbotAppBar('Scanbot Barcode SDK Menu'),
      body: ListView(
        children: <Widget>[
          const BarcodeUseCasesWidget(),
          const BarcodeLegacyUseCasesWidget(),
          const TitleItemWidget(title: 'Other API'),
          BuildMenuItem(context, 'Detect Barcodes from Still Image', _detectBarcodeOnImage),
          BuildMenuItem(context, 'Detect Barcodes from Multiple Still Images', _detectBarcodesOnImages),
        ],
      ),
    );
  }

  /// Detect barcodes from still image
  Future<void> _detectBarcodeOnImage(BuildContext context) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      final response = await selectImageFromLibrary();

      if (response == null || response.path.isEmpty) {
        showAlertDialog(context, "RESULT IS EMPTY");
        return;
      }

      final uriPath = Uri.file(response.path);

      var result = await ScanbotSdk.detectBarcodesOnImage(uriPath,
          barcodeFormats: PredefinedBarcodes.allBarcodeTypes());
      if (result.operationResult == OperationResult.SUCCESS) {
        await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => BarcodesResultPreviewWidget(result)),
        );
      }
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ex.toString()),
      ));
    }
  }

  /// Detect barcodes from multiple still images
  Future<void> _detectBarcodesOnImages(BuildContext context) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      List<Uri> uris = List.empty(growable: true);

      final response = await ImagePicker().pickMultiImage();
      if (response.isEmpty) {
        showAlertDialog(context, "RESULT IS EMPTY");
        return;
      }

      uris = response.map((image) => Uri.file(image.path)).toList();

      var result = await ScanbotSdk.detectBarcodesOnImages(uris,
          barcodeFormats: PredefinedBarcodes.allBarcodeTypes());
      if (result.operationResult == OperationResult.SUCCESS) {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                MultiImageBarcodesResultPreviewWidget(result.barcodeResults)));
      }
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ex.toString()),
      ));
    }
  }
}




