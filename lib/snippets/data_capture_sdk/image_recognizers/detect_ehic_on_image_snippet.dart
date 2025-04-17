import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> _recognizeEhicOnImage(String uriPath) async {
  EuropeanHealthInsuranceCardRecognitionResult result = await ScanbotSdkRecognizeOperations.recognizeHealthInsuranceCardOnImage(uriPath);
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