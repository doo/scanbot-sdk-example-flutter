import 'package:scanbot_sdk/scanbot_sdk.dart';

void startScanning() async {
  // Create the default configuration object.
  var configuration = DocumentScanningFlow();

  var documentResult = await ScanbotSdk.document.startScanner(configuration);
  // Handle the document if the status is 'OK'
  if (documentResult.status == OperationStatus.OK) {}
}
