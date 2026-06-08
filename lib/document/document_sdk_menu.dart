import 'package:flutter/material.dart' hide AspectRatio;
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk_example_flutter/ui/preview/document_preview.dart';

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
            title: 'Straighten document',
            onTap: () => _straightenDocument(context),
          ),
          MenuItemWidget(
            title: 'Analyze document quality',
            onTap: () => _analyzeDocumentQuality(context),
          ),
          MenuItemWidget(
            title: 'Perform OCR',
            onTap: () => _performOCR(context),
          ),
        ],
      ),
    );
  }

  Future<void> _analyzeDocumentQuality(BuildContext context) async {
    final file = await selectImageFromLibrary();
    if (file == null || file.path.isEmpty) return;

    var result = await ScanbotSdk.document.analyzeQualityOnImageFileUri(
      file.path,
      DocumentQualityAnalyzerConfiguration(),
    );
    if (result is Ok<DocumentQualityAnalyzerResult>) {
      await showAlertDialog(
        context,
        title: 'Document Quality',
        result.value.quality.name,
      );
    } else {
      print(result.toString());
    }
  }

  Future<void> _performOCR(BuildContext context) async {
    final file = await selectImageFromLibrary();
    if (file == null || file.path.isEmpty) return;

    var result = await ScanbotSdk.ocrEngine.recognizeOnImageFileUris([
      file.path,
    ]);

    if (result is Ok<PerformOcrResult>) {
      await showAlertDialog(
        context,
        title: 'OCR Result',
        result.value.recognizedText,
      );
    } else {
      print(result.toString());
    }
  }

  Future<void> _straightenDocument(BuildContext context) async {
    final selectedImage = await selectImageFromLibrary();
    if (selectedImage == null || selectedImage.path.isEmpty) return;

    await autorelease(() async {
      // Configure the straightening parameters as needed
      final straighteningParameters = DocumentStraighteningParameters(
        straighteningMode: DocumentStraighteningMode.STRAIGHTEN,
      );

      final documentStraighteningResult =
          await ScanbotSdk.documentEnhancer.straightenImageFileUri(
        selectedImage.path,
        straighteningParameters,
      );

      if (documentStraighteningResult is! Ok<DocumentStraighteningResult>) {
        print(documentStraighteningResult.toString());
        return;
      }

      final documentResult = await ScanbotSdk.document
          .createDocumentFromImageRefs(
              images: [documentStraighteningResult.value.straightenedImage!]);

      if (documentResult is! Ok<DocumentData>) {
        print(documentResult.toString());
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DocumentPreview(documentResult.value),
        ),
      );
    });
  }
}
