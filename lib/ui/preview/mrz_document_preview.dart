import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

import '../../utility/utils.dart';

class MrzDocumentResultPreview extends StatelessWidget {
  final MrzScannerUiResult? uiResult;
  final MrzScannerResult? scannerResult;

  const MrzDocumentResultPreview({
    super.key,
    this.uiResult,
    this.scannerResult,
  }) : assert(uiResult != null || scannerResult != null, 'At least one result must be provided');

  @override
  Widget build(BuildContext context) {
    final document = uiResult?.mrzDocument ?? scannerResult?.document;
    final rawMrz = uiResult?.rawMRZ ?? scannerResult?.rawMRZ;

    if (document == null) {
      return Scaffold(
        appBar: ScanbotAppBar('MRZ Document Preview', showBackButton: true, context: context),
        body: const Center(child: Text('No MRZ data available')),
      );
    }

    final mrz = MRZ(document);

    List<Widget> children = [];

    void addField(String title, String? value, {bool largeGap = false}) {
      children.add(Text(title, style: Theme.of(context).textTheme.titleMedium));
      children.add(Text(value ?? '', style: Theme.of(context).textTheme.bodyMedium));
      children.add(SizedBox(height: largeGap ? 16 : 12));
    }

    addField('Raw MRZ', rawMrz, largeGap: true);
    addField('Given Names', mrz.givenNames.value?.text);
    addField('Surname', mrz.surname.value?.text);
    addField('Birth Date', mrz.birthDate.value?.text);
    addField('Document Number', mrz.documentNumber?.value?.text);
    addField('Nationality', mrz.nationality.value?.text);
    addField('Gender', mrz.gender?.value?.text);
    addField('Expiry Date', mrz.expiryDate?.value?.text);

    return Scaffold(
      appBar: ScanbotAppBar('MRZ Document Preview', showBackButton: true, context: context),
      body: ListView(
        padding: const material.EdgeInsets.all(16),
        children: children,
      ),
    );
  }
}
