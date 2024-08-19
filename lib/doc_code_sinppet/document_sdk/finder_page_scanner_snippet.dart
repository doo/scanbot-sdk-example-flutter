import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> runFinderPageScanner() async {
  var config = DocumentScannerConfiguration();
  // this a A4 format
  config.requiredAspectRatios = [AspectRatio(height: 21.0, width: 29.7)];

  // allow only documents with at least 75% of finder to be scanned
  config.acceptedSizeScore = 0.75;

  // allow only documents with finder aspect ratio to be scanned
  config.ignoreBadAspectRatio = true;

  var result = await ScanbotSdkUi.startDocumentScanner(config);
}
