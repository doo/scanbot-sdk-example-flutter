import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

import '../../utility/utils.dart';

class VinScannerResultPreview extends StatelessWidget {
  final VinScannerResult result;

  const VinScannerResultPreview(this.result, {super.key});

  @override
  Widget build(BuildContext context) {
    final textResult = result.textResult;
    final barcodeResult = result.barcodeResult;

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

    addField('Text VIN', textResult.rawText, textResult.confidence, true);
    addField('Validation', textResult.validationSuccessful ? 'Valid' : 'Invalid');

    for (final word in textResult.wordBoxes) {
      addField('Word', word.text, word.recognitionConfidence);
    }

    for (final symbol in textResult.symbolBoxes) {
      addField('Symbol', symbol.symbol, symbol.recognitionConfidence);
    }

    addField('Barcode VIN', barcodeResult.extractedVIN, null, true);
    addField('Barcode Extraction Status', barcodeResult.status.name);

    if (barcodeResult.rectangle.isNotEmpty) {
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
