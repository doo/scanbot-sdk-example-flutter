import 'package:flutter/material.dart';
import 'package:scanbot_sdk_example_flutter/snippets/document_sdk/multi_page_scanning_snippet.dart';
import 'package:scanbot_sdk_example_flutter/snippets/document_sdk/single_page_scanning_finder_snippet.dart';
import 'package:scanbot_sdk_example_flutter/snippets/document_sdk/single_page_scanning_snippet.dart';

import '../ui/menu_item_widget.dart';
import '../ui/preview/document_preview.dart';
import '../utility/utils.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';

class DocumentUseCasesWidget extends StatelessWidget {
  const DocumentUseCasesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleItemWidget(title: 'Document Scanners (RTU UI)'),
        MenuItemWidget(
          title: 'Single Page Scanning',
          onTap: () => _startSinglePageScanning(context),
        ),
        MenuItemWidget(
          title: 'Single Page Scanning with Finder',
          onTap: () => _startSinglePageWithFinderScanning(context),
        ),
        MenuItemWidget(
          title: 'Multi Page Scanning with Finder',
          onTap: () => _startMultiPageScanning(context),
        ),
        MenuItemWidget(
          title: 'Create Document from Image',
          onTap: () => _createDocumentFromImage(context),
        ),
        MenuItemWidget(
          title: 'Clean stored documents',
          onTap: () => _cleanStoredDocuments(context),
        ),
      ],
    );
  }

  Future<void> startScan({
    required BuildContext context,
    required Future<Result<DocumentData>> Function() scannerFunction,
  }) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    var result = await scannerFunction();
    if (result is Ok<DocumentData>) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DocumentPreview(result.value)),
      );
    } else {
      print(result.toString());
    }
  }

  Future<void> _startSinglePageScanning(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotSdk.document.startScanner(singlePageScanningFlow()),
    );
  }

  Future<void> _startSinglePageWithFinderScanning(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotSdk.document.startScanner(singlePageWithFinderScanningFlow()),
    );
  }

  Future<void> _startMultiPageScanning(BuildContext context) async {
    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotSdk.document.startScanner(multiPageScanningFlow()),
    );
  }

  Future<void> _cleanStoredDocuments(BuildContext context) async {
    await ScanbotSdk.document.deleteAllDocuments();
    await showAlertDialog(context, "Operation status: Success");
  }

  Future<void> _createDocumentFromImage(BuildContext context) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    final response = await selectImageFromLibrary();
    if (response?.path.isNotEmpty ?? false) {
      await autorelease(() async {
        var ref = ImageRef.fromPath(response!.path);
        var result = await ScanbotSdk.document.createDocumentFromImageRefs(
          images: [ref],
        );
        if (result is Ok<DocumentData>) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DocumentPreview(result.value),
            ),
          );
        } else {
          print(result.toString());
        }
      });
    }
  }
}
