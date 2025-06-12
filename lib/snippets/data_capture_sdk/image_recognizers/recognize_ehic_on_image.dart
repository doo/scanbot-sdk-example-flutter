import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> _recognizeEhicOnImage(String uriPath) async {
  var configuration = EuropeanHealthInsuranceCardRecognizerConfiguration();
  configuration.maxExpirationYear = 2100;
  // Configure other parameters as needed.

  EuropeanHealthInsuranceCardRecognitionResult result = await ScanbotSdk.recognizeOperations.recognizeHealthInsuranceCardOnImage(uriPath, configuration);
  if (result.status == EuropeanHealthInsuranceCardRecognitionResultRecognitionStatus.SUCCESS) {
    //  ...
  }
}
String formatHealthInsuranceCardResult(EuropeanHealthInsuranceCardRecognitionResult result) {
    return '''
EHIC first field: ${result.fields.first.type}
Value: ${result.fields.first.value}"
''';
}