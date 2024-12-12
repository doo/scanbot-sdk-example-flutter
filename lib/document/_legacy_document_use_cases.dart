import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

import '../storage/_legacy_pages_repository.dart';
import '../ui/menu_item_widget.dart';
import '../ui/preview/_legacy_document_preview.dart';
import '../ui/progress_dialog.dart';
import '../utility/utils.dart';

import '../snippets/document_sdk/legacy/document_scanner_snippet.dart';
import '../snippets/document_sdk/legacy/finder_document_scanner_snippet.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';

class DocumentUseCasesLegacyWidget extends StatelessWidget {
  DocumentUseCasesLegacyWidget({Key? key}) : super(key: key);

  final LegacyPageRepository _pageRepository = LegacyPageRepository();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleItemWidget(title: 'Legacy Scanners'),
        BuildMenuItem(context, 'Scan Documents', _startDocumentScanning),
        BuildMenuItem(context, 'Scan Finder Documents', _startFinerDocumentScanner),
        BuildMenuItem(context, 'Import Image', _importImage),
        MenuItemWidget(
          title: 'View Image Results',
          endIcon: Icons.keyboard_arrow_right,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LegacyDocumentPreview()),
          )
        ),
      ],
    );
  }

  Future<void> startScan<T>({
    required BuildContext context,
    required Future<T> Function() scannerFunction,
    required void Function(T result) handleResult,
  }) async {
    if (!await checkLicenseStatus(context)) return;

    try {
      final result = await scannerFunction();
      handleResult(result);
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  void handleScanResult(BuildContext context, dynamic result) {
    if (result.operationResult == OperationResult.SUCCESS) {
      _pageRepository.addPages(result.pages);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => LegacyDocumentPreview()),
      );
    }
  }

  Future<void> _startDocumentScanning(BuildContext context) async {
    await startScan<DocumentScanningResult>(
      context: context,
      scannerFunction: () => ScanbotSdkUi.startDocumentScanner(
        documentConfigurationSnippet(),
      ),
      handleResult: (result) => handleScanResult(context, result),
    );
  }

  Future<void> _startFinerDocumentScanner(BuildContext context) async {
    await startScan<FinderDocumentScanningResult>(
      context: context,
      scannerFunction: () => ScanbotSdkUi.startFinderDocumentScanner(
        finderDocumentConfigurationSnippet(),
      ),
      handleResult: (result) => handleScanResult(context, result),
    );
  }

  Future<void> _importImage(BuildContext context) async {
    try {
      final response = await selectImageFromLibrary();

      if (response?.path.isNotEmpty ?? false) {
        final uriPath = Uri.file(response!.path);
        await _createPage(uriPath, context);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => LegacyDocumentPreview()),
        );
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> _createPage(Uri uri, BuildContext context) async {
    if (!await checkLicenseStatus(context)) return;

    final dialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    dialog.style(message: 'Processing');
    dialog.show();

    try {
      var page = await ScanbotSdk.createPage(uri, false);
      page = await ScanbotSdk.detectDocument(page);
      await _pageRepository.addPage(page);
    } catch (e) {
      Logger.root.severe(e);
    } finally {
      await dialog.hide();
    }
  }
}
