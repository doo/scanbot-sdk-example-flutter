import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeMedicalDocumentOnImage(String uriPath) async {
  MedicalCertificateScanningResult result = await ScanbotSdkRecognizeOperations.recognizeMedicalCertificateOnImage(uriPath);
    if (result.scanningSuccessful) {
      //  ...
    }
}

String formatMedicalCertificateResult(MedicalCertificateScanningResult result) {
    return '''
mcFormType: ${result.formType.name}
''';
}