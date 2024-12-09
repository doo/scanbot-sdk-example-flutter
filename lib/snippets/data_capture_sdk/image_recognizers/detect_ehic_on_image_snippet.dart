import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> _recognizeEhicOnImage(String uriPath) async {
    HealthInsuranceCardRecognitionResult result = await ScanbotSdkRecognizeOperations.recognizeHealthInsuranceCardOnImage(uriPath);
    if (result.operationResult == OperationResult.SUCCESS && result.status == HealthInsuranceCardDetectionStatus.SUCCESS) {
      //  ...
    }
}
String formatHealthInsuranceCardResult(HealthInsuranceCardRecognitionResult result) {
    return '''
EHIC first field: ${result.fields.first.type}
Value: ${result.fields.first.value}"
''';
}