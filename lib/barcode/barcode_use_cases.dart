import 'package:flutter/material.dart';

import '../ui/menu_item_widget.dart';
import '../ui/preview/barcode_preview.dart';
import '../utility/utils.dart';

import '../snippets/barcode_sdk/single_scanning_usecase_snippet.dart';
import '../snippets/barcode_sdk/multi_scanning_usecase_snippet.dart';
import '../snippets/barcode_sdk/ar_overlay_usecase_snippet.dart';
import '../snippets/barcode_sdk/find_and_pick_scanning_usecase_snippet.dart';
import '../snippets/barcode_sdk/item_mapping_config_snippet.dart';

import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

class BarcodeUseCasesWidget extends StatelessWidget {
  const BarcodeUseCasesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleItemWidget(title: 'Barcode Scanners (RTU v2.0)'),
        BuildMenuItem(context, "Single Scan with confirmation dialog (RTU v2.0)", startSingleScanV2),
        BuildMenuItem(context, "Multiple Scan (RTU v2.0)", startMultipleScanV2),
        BuildMenuItem(context, "Find and Pick (RTU v2.0)", startFindAndPickScanV2),
        BuildMenuItem(context, "AROverlay (RTU v2.0)", startAROverlayScanV2),
        BuildMenuItem(context, "Info Mapping (RTU v2.0)", startItemMappingScanV2),
      ],
    );
  }

  Future<void> startScan({
    required BuildContext context,
    required Future<ResultWrapper<BarcodeScannerResult>> Function() scannerFunction,
  }) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      var result = await scannerFunction();
      if (result.operationResult == OperationResult.SUCCESS &&
          result.value != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidgetV2(result.value!),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> startSingleScanV2(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () => ScanbotSdkUi.startBarcodeScanner(singleScanningUseCaseSnippet()),
    );
  }

  Future<void> startMultipleScanV2(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () => ScanbotSdkUi.startBarcodeScanner(multipleScanningUseCaseSnippet()),
    );
  }

  Future<void> startFindAndPickScanV2(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () => ScanbotSdkUi.startBarcodeScanner(findAndPickModeUseCaseSnippet()),
    );
  }

  Future<void> startAROverlayScanV2(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () => ScanbotSdkUi.startBarcodeScanner(AROverlayUsecaseSnippet()),
    );
  }

  Future<void> startItemMappingScanV2(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () => ScanbotSdkUi.startBarcodeScanner(itemMappingConfigSnippet()),
    );
  }
}