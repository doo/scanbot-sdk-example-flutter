import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

import '../../utility/utils.dart';

class EuropeanHealthInsuranceCardResultPreview extends StatelessWidget {
  final EuropeanHealthInsuranceCardRecognitionResult result;

  const EuropeanHealthInsuranceCardResultPreview(this.result, {super.key});

  @override
  Widget build(BuildContext context) {
    final fields = result.fields;

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

    addField('Recognition Status', result.status.name, null, largeGap: true);

    for (final field in fields) {
      addField(field.type.name, field.value, field.confidence);
    }

    return Scaffold(
      appBar: ScanbotAppBar('Health Insurance Card Result', showBackButton: true, context: context),
      body: ListView(
        padding: const material.EdgeInsets.all(16),
        children: children,
      ),
    );
  }
}
