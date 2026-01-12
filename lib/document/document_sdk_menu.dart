import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../ui/menu_item_widget.dart';
import '../utility/utils.dart';
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
          const TitleItemWidget(title: 'Other API'),
          MenuItemWidget(
              title: 'Analyze document quality',
              onTap: () => _analyzeDocumentQuality(context)),
          MenuItemWidget(
              title: 'Perform OCR', onTap: () => _performOCR(context)),
        ],
      ),
    );
  }

  Future<void> _analyzeDocumentQuality(BuildContext context) async {
    final response = await selectImageFromLibrary();
    if (response?.path.isNotEmpty ?? false) {
      var result = await ScanbotSdk.document.analyzeQualityOnImageFileUri(
          response!.path, DocumentQualityAnalyzerConfiguration());
      if (result is Ok<DocumentQualityAnalyzerResult>) {
        await showAlertDialog(
            context,
            title: 'Document Quality',
            result.value.quality?.name ?? 'Unknown');
      }
    }
  }

  Future<void> _performOCR(BuildContext context) async {
    final response = await selectImageFromLibrary();
    if (response?.path.isNotEmpty ?? false) {
      var result =
          await ScanbotSdk.ocrEngine.recognizeOnImageFileUris([response!.path]);
      if (result is Ok<PerformOcrResult>) {
        await showAlertDialog(
            context, title: 'OCR Result', result.value.recognizedText);
      }
    }
  }
}
