import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

void startScanning() async {
  // Create the default configuration object.
  var configuration = DocumentScanningFlow();

  var documentResult = await ScanbotSdkUiV2.startDocumentScanner(configuration);
  // Handle the document if the status is 'OK'
  if(documentResult.status == OperationStatus.OK) {
  }
}
