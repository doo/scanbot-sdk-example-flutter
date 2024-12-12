import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../ui/preview/_legacy_barcode_preview.dart';
import '../ui/menu_item_widget.dart';
import '../utility/utils.dart';

import '../snippets/barcode_sdk/legacy/barcode_scanner_snippet.dart';
import '../snippets/barcode_sdk/legacy/batch_barcode_scanner_snippet.dart';
import '../snippets/barcode_sdk/legacy/qr_only_scanner_snippet.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';

class BarcodeLegacyUseCasesWidget extends StatelessWidget {
  const BarcodeLegacyUseCasesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleItemWidget(title: 'Legacy Scanners'),
        BuildMenuItem(context, 'Scan Barcode (all formats: 1D + 2D)', _startBarcodeScanner),
        BuildMenuItem(context, 'Scan QR code (QR format only)', _startQRScanner),
        BuildMenuItem(context, 'Scan Multiple Barcodes (batch mode)', _startBatchBarcodeScanner)
      ],
    );
  }

  Future<void> startScan({
    required BuildContext context,
    required Future<BarcodeScanningResult> Function() scannerFunction,
  }) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      var result = await scannerFunction();
      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(result),
          ),
        );
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> _startBarcodeScanner(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotSdkUi.startBarcodeScanner(barcodeConfigurationSnippet()),
    );
  }

  Future<void> _startQRScanner(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotSdkUi.startBarcodeScanner(QROnlyBarcodeConfigurationSnippet()),
    );
  }

  Future<void> _startBatchBarcodeScanner(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotSdkUi.startBatchBarcodeScanner(
              batchBarcodeConfigurationSnippet()),
    );
  }
}