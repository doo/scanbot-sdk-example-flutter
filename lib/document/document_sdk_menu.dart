import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../ui/menu_item_widget.dart';
import '../utility/utils.dart';
import '_legacy_document_use_cases.dart';
import 'document_use_cases.dart';

class DocumentSdkMenu extends StatelessWidget {
  const DocumentSdkMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScanbotAppBar('Scanbot Document SDK Menu'),
      body: ListView(
        children: <Widget>[
          const DocumentUseCasesWidget(),
          DocumentUseCasesLegacyWidget(),
          const TitleItemWidget(title: 'Other API'),
          MenuItemWidget(title: 'Analyze document quality ', onTap: () => _analyzeDocumentQuality(context)),
          MenuItemWidget(title: 'PerformOCR ', onTap: () => _performOCR(context)),
        ],
      ),
    );
  }

  Future<void> _analyzeDocumentQuality(BuildContext context) async {
    try {
      final response = await selectImageFromLibrary();
      if (response?.path.isNotEmpty ?? false) {
        var result = await ScanbotSdk.analyzeDocumentQuality(response!.path, DocumentQualityAnalyzerConfiguration());
        await showAlertDialog(context, title: 'Document Quality', result.quality?.name ?? 'Unknown');
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> _performOCR(BuildContext context) async {
    try {
      final response = await selectImageFromLibrary();
      if (response?.path.isNotEmpty ?? false) {
        var result = await ScanbotSdk.performOCR(PerformOCRArguments(imageFileUris: [response!.path]));
        await showAlertDialog(context, title: 'OCR Result', result.plainText);
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }
}

