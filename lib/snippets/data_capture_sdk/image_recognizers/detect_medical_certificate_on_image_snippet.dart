import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeMedicalDocumentOnImage(String uriPath) async {
    MedicalCertificateResult result = await ScanbotSdkRecognizeOperations.recognizeMedicalCertificateOnImage(uriPath);
    if (result.operationResult == OperationResult.SUCCESS && result.recognitionSuccessful == true) {
      //  ...
    }
}

String formatMedicalCertificateResult(MedicalCertificateResult result) {
    return '''
mcFormType: ${result.mcFormType}        
croppedDocumentURI:${result.croppedDocumentURI}"
''';
}