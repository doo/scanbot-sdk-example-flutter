import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> _recognizeMrzDocumentOnImage(String uriPath) async {
  var configuration = MrzScannerConfiguration(); 
  configuration.frameAccumulationConfiguration = AccumulatedResultsVerifierConfiguration(
            minimumNumberOfRequiredFramesWithEqualScanningResult: 1);
  configuration.incompleteResultHandling = MrzIncompleteResultHandling.REJECT;
  // Configure other parameters as needed.

  var result = await ScanbotSdk.recognizeOperations.recognizeMrzOnImage(uriPath, configuration);
  if (result.success) {
    //  ...
  }
}

String formatMrzResult(MrzScannerResult result) {
    return '''
Document: ${result.document?.type.name}
rawMrz: ${result.rawMRZ}
''';

}