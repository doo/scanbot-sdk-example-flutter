import 'package:flutter/material.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as scanbot_sdk;

import '../storage/pages_repository.dart';
import '../ui/menu_item_widget.dart';
import '../utility/utils.dart';

import '../ui/preview/_legacy_barcode_preview.dart';
import '../ui/preview/legacy_document_preview.dart';
import '../ui/preview/medical_certificate_preview.dart';

import 'barcode_custom_ui.dart';
import 'document_custom_ui.dart';
import 'medical_certificate_custom_ui.dart';

class CustomUiMenu extends StatelessWidget {
  CustomUiMenu({Key? key}) : super(key: key);

  final PageRepository _pageRepository = PageRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ScanbotRedColor,
        title: const Text('Scanbot Custom UI Menu'),
      ),
      body: ListView(
        children: <Widget>[
          MenuItemWidget(
            startIcon: Icons.edit,
            title: 'Scan Barcode (Custom UI)',
            onTap: () => _startBarcodeCustomUIScanner(context)
          ),
          MenuItemWidget(
            startIcon: Icons.edit,
            title: 'Scan Documents (Custom UI)',
            onTap: () => _startDocumentsCustomUIScanner(context)
          ),
          MenuItemWidget(
            startIcon: Icons.edit,
            title: 'Scan Medical Certificate (Custom UI)',
            onTap: () =>_startMedicalCertificateCustomUIScanner(context)
          ),
        ],
      ),
    );
  }

  Future<void> _startBarcodeCustomUIScanner(BuildContext context) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const BarcodeScannerWidget()),
    );

    if (result is BarcodeScanningResult) {
      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(result)),
      );
    }
  }

  Future<void> _startDocumentsCustomUIScanner(BuildContext context) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const DocumentScannerWidget()),
    );

    if (result is List<scanbot_sdk.Page>) {
      _pageRepository.addPages(result);
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DocumentPreview()),
      );
    }
  }

  Future<void> _startMedicalCertificateCustomUIScanner(BuildContext context) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const MedicalCertificateScannerWidget()),
    );

    if (result is MedicalCertificateResult) {
      await Navigator.of(context).push(
      MaterialPageRoute(
            builder: (context) => MedicalCertificatePreviewWidget(result)),
      );
    }
  }
}




