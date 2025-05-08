import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> documentQualityAnalyzer(String imageFilePath) async {
  /** Detect the quality of the document on image **/
  var quality = await ScanbotSdk.analyzeDocumentQuality(imageFilePath, DocumentQualityAnalyzerConfiguration());
}