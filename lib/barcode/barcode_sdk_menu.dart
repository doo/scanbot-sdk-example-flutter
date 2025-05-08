import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../ui/menu_item_widget.dart';
import '../ui/preview/barcodes_result_preview.dart';
import '../utility/utils.dart';

import 'barcode_use_cases.dart';

class BarcodeSdkMenu extends StatelessWidget {
  const BarcodeSdkMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScanbotAppBar('Scanbot Barcode SDK Menu'),
      body: ListView(
        children: <Widget>[
          const BarcodeUseCasesWidget(),
          const TitleItemWidget(title: 'Other API'),
          MenuItemWidget(title: 'Detect Barcodes from Still Image', onTap: () => _detectBarcodeOnImage(context)),
          MenuItemWidget(title: 'Detect Barcodes from Multiple Still Images', onTap: () => _detectBarcodesOnImages(context)),
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
        await showAlertDialog(context, title: "Info", "No image picked.");
        return;
      }

      final uriPath = Uri.file(response.path);

      var result = await ScanbotSdk.detectBarcodesOnImage(
          uriPath,
          BarcodeScannerConfiguration());

      if(!result.success) {
        await showAlertDialog(context, title: "Info", "No barcodes detected.");
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(result.barcodes)),
      );

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
        await showAlertDialog(context, title: "Info", "No image picked.");
        return;
      }

      showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          }
      );

      uris = response.map((image) => Uri.file(image.path)).toList();

      List<BarcodeItem> allBarcodes = [];

      for (var uri in uris) {
        var result = await ScanbotSdk.detectBarcodesOnImage(
            uri,
            BarcodeScannerConfiguration());

        allBarcodes.addAll(result.barcodes);
      }

      Navigator.of(context).pop();

      if (allBarcodes.isNotEmpty) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(allBarcodes),
          ),
        );
      } else {
        await showAlertDialog(context, title: "Info", "No barcodes detected.");
        return;
      }

    } catch (ex) {
      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ex.toString()),
      ));
    }
  }
}




