import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeCreditCardOnImage(String uriPath) async {
  var configuration = CreditCardScannerConfiguration();
  configuration.requireCardholderName = true;
  // Configure other parameters as needed.

  var result = await ScanbotSdk.creditCard.scanFromImageFileUri(
    uriPath,
    configuration,
  );
  if (result is Ok<CreditCardScanningResult> &&
      result.value.scanningStatus == CreditCardScanningStatus.SUCCESS) {
    /** Handle the result **/
  } else {
    // Handle the error, e.g. show a message to the user.
  }
}

String formatCheckResult(CreditCardScanningResult result) {
  return "CreditCard Type: ${result.creditCard?.type.fullName}";
}
