// import {selectImageFromLibrary} from '@utils';
// import ScanbotSDK from 'react-native-scanbot-sdk';

import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> documentQualityAnalyzer() async {
  /**
   * Select an image from the Image Library
   * Return early if no image is selected or there is an issue with selecting an image
   **/
  var selectedImageResultPath = await selectImageFromLibrary();

  /** Detect the quality of the document on image **/
  var quality = await ScanbotSdk.analyzeDocumentQuality(selectedImageResultPath);
}

Future<String> selectImageFromLibrary() async {
  return "";
}