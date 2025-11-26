
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future mockCamera() async {
  /**
   * For Android:
   *  API >= 33, READ_MEDIA_IMAGES and READ_MEDIA_VIDEO permissions are required.
   *  API < 33, READ_EXTERNAL_STORAGE permission is required.
   *  The image must have even values for both width and height.
   */
  await ScanbotSdk.mockCamera("{path to your image file}");
}