import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

import '../../utility/utils.dart';

class MedicalCertificatePreviewWidget extends StatelessWidget {
  final MedicalCertificateScanningResult result;

  const MedicalCertificatePreviewWidget(this.result, {super.key});

  @override
  Widget build(BuildContext context) {
    final checkBoxes = result.checkBoxes;
    final patientFields = result.patientInfoBox.fields;
    final dateFields = result.dates;

    return Scaffold(
      appBar: ScanbotAppBar('Scanned Certificate', showBackButton: true, context: context),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildImagePreview(result.croppedImage),
          const SizedBox(height: 24),
          ..._buildFields(context, checkBoxes, patientFields, dateFields),
        ],
      ),
    );
  }

  Widget _buildImagePreview(ImageRef? image) {
    if (image?.buffer != null) {
      return Image.memory(image!.buffer!, fit: BoxFit.contain);
    } else {
      return const Text('No image available');
    }
  }

  List<Widget> _buildFields(
    BuildContext context,
    List<MedicalCertificateCheckBox> checkBoxes,
    List<MedicalCertificatePatientInfoField> patientFields,
    List<MedicalCertificateDateRecord> dateFields,
  ) {
    final List<Widget> children = [];

    void add(String title, String? value, double? confidence,
        {bool large = false}) {
      children.add(Text(title, style: Theme.of(context).textTheme.titleMedium));
      if (value != null && value.isNotEmpty) {
        children
            .add(Text(value, style: Theme.of(context).textTheme.bodyMedium));
      }
      if (confidence != null && confidence.isFinite) {
        children.add(Text(
          'Confidence: ${confidence.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.labelSmall,
        ));
      }
      children.add(SizedBox(height: large ? 16 : 12));
    }

    for (var cb in checkBoxes) {
      add(cb.type.name, cb.checked.toString(), cb.checkedConfidence);
    }

    for (var pf in patientFields) {
      add(pf.type.name, pf.value, pf.recognitionConfidence);
    }

    for (var df in dateFields) {
      add(df.type.name, df.value, df.recognitionConfidence);
    }

    return children;
  }
}
