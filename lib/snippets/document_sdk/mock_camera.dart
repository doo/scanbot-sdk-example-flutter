
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future mockCamera() async {
  var config = MockCameraParams(imageFileUri: "{path to your image file}");

  /**
   * On Android, the MANAGE_EXTERNAL_STORAGE permission is required, and the image must have even values for both width and height.
   */
  await ScanbotSdk.mockCamera(config);
}