import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> _recognizeMrzDocumentOnImage(String uriPath) async {
    var result = await ScanbotSdkRecognizeOperations.recognizeMrzOnImage(uriPath);
    if (result.operationResult == OperationResult.SUCCESS) {
      //  ...
    }
}

String formatMrzResult(MrzScanningResult result) {
    return '''
Document: ${result.documentType}        
rawMrz: ${result.rawMrz}        
documentNumber: ${result.document?.documentNumber?.value?.text}
''';

}