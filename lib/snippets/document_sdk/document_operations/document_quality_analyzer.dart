import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> documentQualityAnalyzer(String imageFilePath) async {
  /** Detect the quality of the document on image **/
  var result = await ScanbotSdk.document.analyzeQualityOnImageFileUri(
    imageFilePath,
    DocumentQualityAnalyzerConfiguration(),
  );

  if (result is Ok<DocumentQualityAnalyzerResult>) {
    /** Handle the DQA Result */
  } else {
    print(result.toString());
  }
}
