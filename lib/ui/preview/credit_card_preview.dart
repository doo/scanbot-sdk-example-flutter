import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../../utility/utils.dart';

class CreditCardResultPreview extends StatelessWidget {
  final CreditCardScannerUiResult? uiResult;
  final CreditCardScanningResult? scanningResult;

  const CreditCardResultPreview({
    super.key,
    this.uiResult,
    this.scanningResult,
  }) : assert(uiResult != null || scanningResult != null,
  'At least one result must be provided');

  @override
  Widget build(BuildContext context) {
    final doc = uiResult?.creditCard ?? scanningResult?.creditCard;
    final recognitionStatus = uiResult?.recognitionStatus.name ?? scanningResult?.scanningStatus.name;

    if (doc == null) {
      return Scaffold(
        appBar: ScanbotAppBar('Credit Card Result', showBackButton: true, context: context),
        body: const Center(child: Text('No credit card data available')),
      );
    }

    final creditCard = CreditCard(doc);

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

    addField('Recognition Status', recognitionStatus, null, largeGap: true);
    addField('Card Number', creditCard.cardNumber.value?.text, creditCard.cardNumber.value?.confidence);
    addField('Cardholder Name', creditCard.cardholderName?.value?.text, creditCard.cardholderName?.value?.confidence);
    addField('Expiry Date', creditCard.expiryDate?.value?.text, creditCard.expiryDate?.value?.confidence);

    return Scaffold(
      appBar: ScanbotAppBar('Credit Card Result', showBackButton: true, context: context),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: children,
      ),
    );
  }
}
