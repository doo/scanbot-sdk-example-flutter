import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeCreditCardOnImage(String uriPath) async {
  var configuration = CreditCardScannerConfiguration();
  configuration.scanningMode = CreditCardScanningMode.SINGLE_SHOT;
  // Configure other parameters as needed.

  CreditCardScanningResult result = await ScanbotSdk.recognizeOperations.recognizeCreditCardOnImage(uriPath, configuration);
  if (result.scanningStatus == CreditCardScanningStatus.SUCCESS) {
    //  ...
  }
}

String formatCheckResult(CreditCardScanningResult result) {
  return "CreditCard Type: ${result.creditCard?.type.fullName}";
}