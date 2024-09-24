import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> runSinglePageScannerWithGuidance() async {
  var config = DocumentScannerConfiguration();

  config.multiPageEnabled = false;
  config.multiPageButtonHidden = true;
  config.textHintBadAngles = "Hold your phone parallel to the document";
  config.textHintOK = "Hold your phone, steady, trying to scan";
  config.textHintBadAspectRatio = "The document is not in the correct format";
  config.textHintTooDark = "Its too dark, please add more light";
  config.textHintTooSmall = "Document too small, please move closer";
  config.textHintTooNoisy = "Image too noisy, please move to a better lit area";
  config.textHintNothingDetected = "No document detected, please try again";

  var result = await ScanbotSdkUi.startDocumentScanner(config);
}
