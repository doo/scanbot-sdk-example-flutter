import 'package:flutter/material.dart';

import '../ui/menu_item_widget.dart';
import '../ui/preview/barcodes_result_preview.dart';
import '../utility/utils.dart';

import '../snippets/barcode_sdk/rtuUi_single_scanning_usecase.dart';
import '../snippets/barcode_sdk/rtuUi_multi_scanning_usecase.dart';
import '../snippets/barcode_sdk/rtuUi_ar_overlay_usecase.dart';
import '../snippets/barcode_sdk/rtuUi_find_and_pick_scanning_usecase.dart';
import '../snippets/barcode_sdk/rtuUi_mapping_item_config.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

class BarcodeUseCasesWidget extends StatelessWidget {
  const BarcodeUseCasesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleItemWidget(title: 'Barcode Scanners (RTU)'),
        MenuItemWidget(title: "Single Scan with confirmation dialog", onTap: () => startSingleScan(context)),
        MenuItemWidget(title: "Multiple Scan", onTap: () => startMultipleScan(context)),
        MenuItemWidget(title: "Find and Pick", onTap: () => startFindAndPickScan(context)),
        MenuItemWidget(title: "Multiple Scan With AR Overlay", onTap: () => startAROverlayScan(context)),
        MenuItemWidget(title: "Multiple Scan with Info Mapping", onTap: () => startItemMappingScan(context)),
      ],
    );
  }

  Future<void> startScan({
    required BuildContext context,
    required Future<ResultWrapper<BarcodeScannerUiResult>> Function() scannerFunction,
  }) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      /// if scannerConfiguration.returnBarcodeImage = true, you must use autorelease for result object
      /// otherwise you'll get exception "AutoReleasable objects must be created within autorelease"
      // await autorelease(() async {

      var result = await scannerFunction();

      /// if you want to use image later, call encodeImages() to save in buffer
      // if(enableImagesInScannedBarcodesResults)
      //   result.data?.encodeImages();

      if (result.status == OperationStatus.OK && result.data != null) {
        final barcodeItems = result.data!.items.map((item) => item.barcode).toList();

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(barcodeItems),
          ),
        );
      }
      // });
    } catch (e) {
      print(e);
    }
  }

  Future<void> startSingleScan(BuildContext context) async {
    var configuration = rtuUiSingleScanningUseCase();
    configuration.scannerConfiguration.barcodeFormats = selectedFormatsNotifier.value.toList();

    await startScan(
      context: context,
      scannerFunction: () => ScanbotSdkUiV2.startBarcodeScanner(configuration),
    );
  }

  Future<void> startMultipleScan(BuildContext context) async {
    var configuration = rtuUiMultipleScanningUseCase();
    configuration.scannerConfiguration.barcodeFormats = selectedFormatsNotifier.value.toList();

    await startScan(
      context: context,
      scannerFunction: () => ScanbotSdkUiV2.startBarcodeScanner(configuration),
    );
  }

  Future<void> startFindAndPickScan(BuildContext context) async {
    var configuration = rtuUiFindAndPickModeUseCase();
    configuration.scannerConfiguration.barcodeFormats = selectedFormatsNotifier.value.toList();

    await startScan(
      context: context,
      scannerFunction: () => ScanbotSdkUiV2.startBarcodeScanner(configuration),
    );
  }

  Future<void> startAROverlayScan(BuildContext context) async {
    var configuration = rtuUiArOverlayUseCase();
    configuration.scannerConfiguration.barcodeFormats = selectedFormatsNotifier.value.toList();

    await startScan(
      context: context,
      scannerFunction: () => ScanbotSdkUiV2.startBarcodeScanner(configuration),
    );
  }

  Future<void> startItemMappingScan(BuildContext context) async {
    var configuration = rtuUiMappingItemConfiguration();
    configuration.scannerConfiguration.barcodeFormats = selectedFormatsNotifier.value.toList();

    await startScan(
      context: context,
      scannerFunction: () => ScanbotSdkUiV2.startBarcodeScanner(configuration),
    );
  }
}