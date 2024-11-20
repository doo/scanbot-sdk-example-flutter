import 'package:flutter/material.dart';

import '../ui/menu_item_widget.dart';
import '../utility/utils.dart';

import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

class DocumentUseCasesWidget extends StatelessWidget {
  const DocumentUseCasesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleItemWidget(title: 'Document Scanners (RTU v2.0)'),
        BuildMenuItem(context, 'Scan Documents (RTU v2.0)', _startDocumentScanningV2),
        // BuildMenuItem(context, "Single Scan with confirmation dialog (RTU v2.0)",
          // onTap: () {
            // startSingleScanV2(context);
          // },
        // ),
      ],
    );
  }

  Future<void> startScan({
    required BuildContext context,
    required Future<ResultWrapper<DocumentData>> Function() scannerFunction,
  }) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      var result = await scannerFunction();
      if (result.operationResult == OperationResult.SUCCESS) {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => BarcodesResultPreviewWidgetV2(result.value!),
        //   ),
        // );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _startDocumentScanningV2(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotSdkUi.startDocumentScannerV2(DocumentScanningFlow()),
    );
  }
}
