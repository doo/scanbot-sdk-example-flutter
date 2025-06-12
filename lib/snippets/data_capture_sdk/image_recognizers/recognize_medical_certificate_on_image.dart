import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeMedicalDocumentOnImage(String uriPath) async {
  var configuration = MedicalCertificateScanningParameters();
  configuration.recognizePatientInfoBox = true;
  // Configure other parameters as needed.

  MedicalCertificateScanningResult result = await ScanbotSdk.recognizeOperations.recognizeMedicalCertificateOnImage(uriPath, configuration);
  if (result.scanningSuccessful) {
    //  ...
  }
}

String formatMedicalCertificateResult(MedicalCertificateScanningResult result) {
    return '''
mcFormType: ${result.formType.name}
''';
}