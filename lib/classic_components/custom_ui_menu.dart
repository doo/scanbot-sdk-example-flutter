import 'package:flutter/material.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as scanbot_sdk;
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

import '../storage/_legacy_pages_repository.dart';
import '../ui/menu_item_widget.dart';
import '../ui/preview/barcodes_result_preview.dart';
import '../utility/utils.dart';

import '../ui/preview/_legacy_document_preview.dart';
import '../ui/preview/medical_certificate_preview.dart';

import 'barcode_custom_ui.dart';
import 'document_custom_ui.dart';
import 'medical_certificate_custom_ui.dart';

class CustomUiMenu extends StatelessWidget {
  CustomUiMenu({Key? key}) : super(key: key);

  final LegacyPageRepository _pageRepository = LegacyPageRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScanbotAppBar('Scanbot Custom UI Menu'),
      body: ListView(
        children: <Widget>[
          MenuItemWidget(title: 'Scan Barcode', onTap: () => _startBarcodeCustomUIScanner(context)),
          MenuItemWidget(title: 'Scan Documents', onTap: () => _startDocumentsCustomUIScanner(context)),
          MenuItemWidget(title: 'Scan Medical Certificate', onTap: () => _startMedicalCertificateCustomUIScanner(context)),
        ],
      ),
    );
  }

  Future<void> _startBarcodeCustomUIScanner(BuildContext context) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const BarcodeScannerWidget()),
    );

    if (result is BarcodeScannerResult) {
      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(result.barcodes)),
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
        MaterialPageRoute(builder: (context) => LegacyDocumentPreview()),
      );
    }
  }

  Future<void> _startMedicalCertificateCustomUIScanner(BuildContext context) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const MedicalCertificateScannerWidget()),
    );

    if (result is MedicalCertificateScanningResult) {
      await Navigator.of(context).push(
      MaterialPageRoute(
            builder: (context) => MedicalCertificatePreviewWidget(result)),
      );
    }
  }
}




