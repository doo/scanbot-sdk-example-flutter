import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> _recognizeMrzDocumentOnImage(String uriPath) async {
    var result = await ScanbotSdkRecognizeOperations.recognizeMrzOnImage(uriPath);
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