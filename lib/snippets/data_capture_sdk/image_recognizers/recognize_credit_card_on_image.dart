import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeCreditCardOnImage(String uriPath) async {
  CreditCardScanningResult result = await ScanbotSdk.recognizeOperations.recognizeCreditCardOnImage(uriPath, CreditCardScannerConfiguration());
  if (result.scanningStatus == CreditCardScanningStatus.SUCCESS) {
    //  ...
  }
}

String formatCheckResult(CreditCardScanningResult result) {
  return "CreditCard Type: ${result.creditCard?.type.fullName}";
}