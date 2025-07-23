import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../../utility/utils.dart';

class CheckDocumentResultPreview extends StatelessWidget {
  final CheckScannerUiResult? uiResult;
  final CheckScanningResult? scanningResult;

  const CheckDocumentResultPreview({
    super.key,
    this.uiResult,
    this.scanningResult,
  }) : assert(uiResult != null || scanningResult != null,
  'At least one result must be provided');

  @override
  Widget build(BuildContext context) {
    final genericDocument = uiResult?.check ?? scanningResult?.check;
    final croppedImage = uiResult?.croppedImage ?? scanningResult?.croppedImage;

    return Scaffold(
      appBar: ScanbotAppBar('Check Document Preview', showBackButton: true, context: context),
      body: genericDocument == null
          ? const Center(child: Text('No check data available'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildImagePreview(croppedImage),
                const SizedBox(height: 24),
                ..._buildDocumentFields(context, genericDocument),
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

  List<Widget> _buildDocumentFields(BuildContext context, GenericDocument doc) {
    final List<Widget> fields = [];

    void add(String title, String? value, {bool large = false}) {
      fields.add(Text(title, style: Theme.of(context).textTheme.titleMedium));
      fields.add(
          Text(value ?? '', style: Theme.of(context).textTheme.bodyMedium));
      fields.add(SizedBox(height: large ? 16 : 12));
    }

    switch (doc.type.name) {
      case USACheck.DOCUMENT_TYPE:
        final d = USACheck(doc);
        add('Account Number', d.accountNumber.value?.text);
        add('Transit Number', d.transitNumber.value?.text);
        add('Auxiliary On-Us', d.auxiliaryOnUs?.value?.text);
        add('Raw String', d.rawString.value?.text, large: true);
        add('Font Type', d.fontType?.value?.text);
        break;
      case UAECheck.DOCUMENT_TYPE:
        final d = UAECheck(doc);
        add('Account Number', d.accountNumber.value?.text);
        add('Cheque Number', d.chequeNumber.value?.text);
        add('Routing Number', d.routingNumber.value?.text);
        add('Raw String', d.rawString.value?.text, large: true);
        add('Font Type', d.fontType?.value?.text);
        break;
      case FRACheck.DOCUMENT_TYPE:
        final d = FRACheck(doc);
        add('Account Number', d.accountNumber.value?.text);
        add('Cheque Number', d.chequeNumber.value?.text);
        add('Routing Number', d.routingNumber.value?.text);
        add('Raw String', d.rawString.value?.text, large: true);
        add('Font Type', d.fontType?.value?.text);
        break;
      case ISRCheck.DOCUMENT_TYPE:
        final d = ISRCheck(doc);
        add('Account Number', d.accountNumber.value?.text);
        add('Bank Number', d.bankNumber.value?.text);
        add('Branch Number', d.branchNumber.value?.text);
        add('Cheque Number', d.chequeNumber.value?.text);
        add('Raw String', d.rawString.value?.text, large: true);
        add('Font Type', d.fontType?.value?.text);
        break;
      case KWTCheck.DOCUMENT_TYPE:
        final d = KWTCheck(doc);
        add('Account Number', d.accountNumber.value?.text);
        add('Cheque Number', d.chequeNumber.value?.text);
        add('Sort Code', d.sortCode.value?.text);
        add('Raw String', d.rawString.value?.text, large: true);
        add('Font Type', d.fontType?.value?.text);
        break;
      case AUSCheck.DOCUMENT_TYPE:
        final d = AUSCheck(doc);
        add('Account Number', d.accountNumber.value?.text);
        add('BSB', d.bsb.value?.text);
        add('Transaction Code', d.transactionCode.value?.text);
        add('Aux Domestic', d.auxDomestic?.value?.text);
        add('Extra Aux Domestic', d.extraAuxDomestic?.value?.text);
        add('Raw String', d.rawString.value?.text, large: true);
        add('Font Type', d.fontType?.value?.text);
        break;
      case INDCheck.DOCUMENT_TYPE:
        final d = INDCheck(doc);
        add('Account Number', d.accountNumber.value?.text);
        add('Serial Number', d.serialNumber.value?.text);
        add('Transaction Code', d.transactionCode.value?.text);
        add('Sort Number', d.sortNumber?.value?.text);
        add('Raw String', d.rawString.value?.text, large: true);
        add('Font Type', d.fontType?.value?.text);
        break;
      case CANCheck.DOCUMENT_TYPE:
        final d = CANCheck(doc);
        add('Account Number', d.accountNumber.value?.text);
        add('Bank Number', d.bankNumber.value?.text);
        add('Cheque Number', d.chequeNumber.value?.text);
        add('Transit Number', d.transitNumber.value?.text);
        add('Designation Number', d.designationNumber?.value?.text);
        add('Transaction Code', d.transactionCode?.value?.text);
        add('Raw String', d.rawString.value?.text, large: true);
        add('Font Type', d.fontType?.value?.text);
        break;
      default:
        break;
    }

    return fields;
  }
}