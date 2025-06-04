import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:scanbot_sdk_example_flutter/snippets/document_sdk/multi_page_scanning_snippet.dart';
import 'package:scanbot_sdk_example_flutter/snippets/document_sdk/single_page_scanning_finder_snippet.dart';
import 'package:scanbot_sdk_example_flutter/snippets/document_sdk/single_page_scanning_snippet.dart';

import '../ui/menu_item_widget.dart';
import '../ui/preview/document_preview.dart';
import '../utility/utils.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

class DocumentUseCasesWidget extends StatelessWidget {
  const DocumentUseCasesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleItemWidget(title: 'Document Scanners (RTU v2.0)'),
        MenuItemWidget(title: 'Single Page Scanning', onTap: () => _startSinglePageScanning(context)),
        MenuItemWidget(title: 'Single Page Scanning with Finder', onTap: () => _startSinglePageWithFinderScanning(context)),
        MenuItemWidget(title: 'Multi Page Scanning with Finder', onTap: () => _startMultiPageScanning(context)),
        MenuItemWidget(title: 'Create Document from Image', onTap: () => _createDocumentFromImage(context)),
        MenuItemWidget(title: 'Clean stored documents', onTap: () => _cleanStoredDocuments(context)),
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
      if (result.status == OperationStatus.OK &&
          result.data != null) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DocumentPreview(result.data!),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _startSinglePageScanning(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotSdkUiV2.startDocumentScanner(singlePageScanningFlow()),
    );
  }

  Future<void> _startSinglePageWithFinderScanning(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotSdkUiV2.startDocumentScanner(singlePageWithFinderScanningFlow()),
    );
  }

  Future<void> _startMultiPageScanning(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotSdkUiV2.startDocumentScanner(multiPageScanningFlow()),
    );
  }

  Future<void> _cleanStoredDocuments(BuildContext context) async {
    // This is crashing
    await ScanbotSdk.document.deleteAllDocuments();
  }

  Future<void> _createDocumentFromImage(BuildContext context) async {
    try {
      if (!await checkLicenseStatus(context)) {
        return;
      }

      final response = await selectImageFromLibrary();
      if (response?.path.isNotEmpty ?? false) {
        var result = await ScanbotSdk.document.createDocument(CreateDocumentParams(imageFileUris: [response!.path]));
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DocumentPreview(result),
          ),
        );
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }
}
