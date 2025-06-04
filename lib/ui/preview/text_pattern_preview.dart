import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

import '../../utility/utils.dart';

class TextPatternScannerUiResultPreview extends StatelessWidget {
  final TextPatternScannerUiResult result;

  const TextPatternScannerUiResultPreview(this.result, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    void addField(String title, String? value, double? confidence, {bool largeGap = false}) {
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

    // Header
    addField('Raw Text', result.rawText, result.confidence, largeGap: true);

    // Words
    for (final word in result.wordBoxes) {
      addField('Word', word.text, word.recognitionConfidence);
    }

    // Symbols
    for (final symbol in result.symbolBoxes) {
      addField('Symbol', symbol.symbol, symbol.recognitionConfidence);
    }

    return Scaffold(
      appBar: ScanbotAppBar('Text Pattern Result', showBackButton: true, context: context),
      body: ListView(
        padding: const material.EdgeInsets.all(16),
        children: children,
      ),
    );
  }
}
