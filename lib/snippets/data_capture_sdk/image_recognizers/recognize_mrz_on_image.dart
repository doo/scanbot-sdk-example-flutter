import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> recognizeMrzDocumentOnImage(String uriPath) async {
  var configuration = MrzScannerConfiguration();
  configuration.incompleteResultHandling = MrzIncompleteResultHandling.REJECT;
  // Configure other parameters as needed.

  var result =
      await ScanbotSdk.mrz.scanFromImageFileUri(uriPath, configuration);
  if (result is Ok<MrzScannerResult> && result.value.success) {
    /** Handle the result **/
  }
}

String formatMrzResult(MrzScannerResult result) {
  return '''
Document: ${result.document?.type.name}
rawMrz: ${result.rawMRZ}
''';
}
