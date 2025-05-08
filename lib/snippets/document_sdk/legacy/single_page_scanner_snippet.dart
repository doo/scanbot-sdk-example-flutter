import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

Future<void> runSinglePageScanner() async {
  var config = DocumentScannerConfiguration();
  config.multiPageEnabled = false;
  config.multiPageButtonHidden = true;

  // allow only A4 format documents to be scanned
  config.requiredAspectRatios = [AspectRatio(height: 21.0, width: 29.7)];

  var result = await ScanbotSdkUi.startDocumentScanner(config);
}
