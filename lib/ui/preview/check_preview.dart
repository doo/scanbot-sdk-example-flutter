import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../../utility/utils.dart';

class CheckDocumentResultPreview extends StatelessWidget {
  final CheckScanningResult result;

  const CheckDocumentResultPreview(this.result, {super.key});

  @override
  Widget build(BuildContext context) {
    final genericDocument = result.check;
    if (genericDocument == null) {
      return Scaffold(
        appBar: ScanbotAppBar('Check Document Preview', showBackButton: true, context: context),
        body: const Center(child: Text('No check data available')),
      );
    }

    List<Widget> children = [];

    void addField(String title, String? value, {bool largeGap = false}) {
      children.add(Text(title, style: Theme.of(context).textTheme.titleMedium));
      children.add(Text(value ?? '', style: Theme.of(context).textTheme.bodyMedium));
      children.add(SizedBox(height: largeGap ? 16 : 12));
    }

    switch (genericDocument.type.name) {
      case USACheck.DOCUMENT_TYPE:
        final doc = USACheck(genericDocument);
        addField('Account Number', doc.accountNumber.value?.text);
        addField('Transit Number', doc.transitNumber.value?.text);
        addField('Auxiliary On-Us', doc.auxiliaryOnUs?.value?.text);
        addField('Raw String', doc.rawString.value?.text, largeGap: true);
        addField('Font Type', doc.fontType?.value?.text);
        break;
      case UAECheck.DOCUMENT_TYPE:
        final doc = UAECheck(genericDocument);
        addField('Account Number', doc.accountNumber.value?.text);
        addField('Cheque Number', doc.chequeNumber.value?.text);
        addField('Routing Number', doc.routingNumber.value?.text);
        addField('Raw String', doc.rawString.value?.text, largeGap: true);
        addField('Font Type', doc.fontType?.value?.text);
        break;
      case FRACheck.DOCUMENT_TYPE:
        final doc = FRACheck(genericDocument);
        addField('Account Number', doc.accountNumber.value?.text);
        addField('Cheque Number', doc.chequeNumber.value?.text);
        addField('Routing Number', doc.routingNumber.value?.text);
        addField('Raw String', doc.rawString.value?.text, largeGap: true);
        addField('Font Type', doc.fontType?.value?.text);
        break;
      case ISRCheck.DOCUMENT_TYPE:
        final doc = ISRCheck(genericDocument);
        addField('Account Number', doc.accountNumber.value?.text);
        addField('Bank Number', doc.bankNumber.value?.text);
        addField('Branch Number', doc.branchNumber.value?.text);
        addField('Cheque Number', doc.chequeNumber.value?.text);
        addField('Raw String', doc.rawString.value?.text, largeGap: true);
        addField('Font Type', doc.fontType?.value?.text);
        break;
      case KWTCheck.DOCUMENT_TYPE:
        final doc = KWTCheck(genericDocument);
        addField('Account Number', doc.accountNumber.value?.text);
        addField('Cheque Number', doc.chequeNumber.value?.text);
        addField('Sort Code', doc.sortCode.value?.text);
        addField('Raw String', doc.rawString.value?.text, largeGap: true);
        addField('Font Type', doc.fontType?.value?.text);
        break;
      case AUSCheck.DOCUMENT_TYPE:
        final doc = AUSCheck(genericDocument);
        addField('Account Number', doc.accountNumber.value?.text);
        addField('BSB', doc.bsb.value?.text);
        addField('Transaction Code', doc.transactionCode.value?.text);
        addField('Aux Domestic', doc.auxDomestic?.value?.text);
        addField('Extra Aux Domestic', doc.extraAuxDomestic?.value?.text);
        addField('Raw String', doc.rawString.value?.text, largeGap: true);
        addField('Font Type', doc.fontType?.value?.text);
        break;
      case INDCheck.DOCUMENT_TYPE:
        final doc = INDCheck(genericDocument);
        addField('Account Number', doc.accountNumber.value?.text);
        addField('Serial Number', doc.serialNumber.value?.text);
        addField('Transaction Code', doc.transactionCode.value?.text);
        addField('Sort Number', doc.sortNumber?.value?.text);
        addField('Raw String', doc.rawString.value?.text, largeGap: true);
        addField('Font Type', doc.fontType?.value?.text);
        break;
      case CANCheck.DOCUMENT_TYPE:
        final doc = CANCheck(genericDocument);
        addField('Account Number', doc.accountNumber.value?.text);
        addField('Bank Number', doc.bankNumber.value?.text);
        addField('Cheque Number', doc.chequeNumber.value?.text);
        addField('Transit Number', doc.transitNumber.value?.text);
        addField('Designation Number', doc.designationNumber?.value?.text);
        addField('Transaction Code', doc.transactionCode?.value?.text);
        addField('Raw String', doc.rawString.value?.text, largeGap: true);
        addField('Font Type', doc.fontType?.value?.text);
        break;
      default:
        break;
    }

    return Scaffold(
      appBar: ScanbotAppBar('Check Document Preview', showBackButton: true, context: context),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: children,
      ),
    );
  }
}