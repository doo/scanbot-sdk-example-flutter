import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

Future<void> runSinglePageAutoSnap() async {
  var config = DocumentScannerConfiguration();

  config.autoSnappingButtonTitle = "Auto-Snap";
  config.autoSnappingButtonHidden = false;
  config.autoSnappingEnabled = true;

  var result = await ScanbotSdkUi.startDocumentScanner(config);
}
