
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future mockCamera() async {
  var config = MockCameraParams(imageFileUri: "{path to your image file}");

  /**
   * For Android:
   *  API >= 33, READ_MEDIA_IMAGES and READ_MEDIA_VIDEO permissions are required.
   *  API < 33, READ_EXTERNAL_STORAGE permission is required.
   *  The image must have even values for both width and height.
   */
  await ScanbotSdk.mockCamera(config);
}