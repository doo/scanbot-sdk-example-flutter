import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

import '../../utility/utils.dart';

class VinScannerResultPreview extends StatelessWidget {
    final VinScannerUiResult? uiResult;
    final VinScannerResult? scanningResult;

    const VinScannerResultPreview({
    super.key,
    this.uiResult,
    this.scanningResult,
    }) : assert(uiResult != null || scanningResult != null,
    'At least one result must be provided');

    @override
  Widget build(BuildContext context) {
    final textResult = scanningResult?.textResult ?? uiResult?.textResult;
    final barcodeResult = scanningResult?.barcodeResult ?? uiResult?.barcodeResult;

    if (barcodeResult == null) {
      return Scaffold(
        appBar: ScanbotAppBar('VIN Scanner Result', showBackButton: true, context: context),
        body: const Center(child: Text('No barcode data available')),
      );
    }

    List<Widget> children = [];

    void addField(String title, String? value, [double? confidence, bool largeGap = false]) {
      children.add(Text(title, style: Theme.of(context).textTheme.titleMedium));
      if (value != null && value.isNotEmpty) {
        children.add(Text(value, style: Theme.of(context).textTheme.bodyMedium));
      }
      if (confidence != null && confidence.isFinite) {
        children.add(Text('Confidence: ${confidence.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.labelSmall));
      }
      children.add(SizedBox(height: largeGap ? 16 : 12));
    }

    if(textResult != null) {
      addField('Text VIN', textResult.rawText, textResult.confidence, true);
      addField(
          'Validation', textResult.validationSuccessful ? 'Valid' : 'Invalid');

      for (final word in textResult.wordBoxes) {
        addField('Word', word.text, word.recognitionConfidence);
      }
    }

    addField('Barcode VIN', barcodeResult.extractedVIN, null, true);
    addField('Barcode Extraction Status', barcodeResult.status.name);

    if (barcodeResult!.rectangle.isNotEmpty) {
      final rectText = barcodeResult.rectangle.map((p) => '(${p.x}, ${p.y})').join(', ');
      addField('Barcode Rectangle', rectText);
    }

    return Scaffold(
      appBar: ScanbotAppBar('VIN Scanner Result', showBackButton: true, context: context),
      body: ListView(
        padding: const material.EdgeInsets.all(16),
        children: children,
      ),
    );
  }
}
