import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> initialize() async {
  var config = SdkConfiguration(
    licenseKey: "<YOUR_SCANBOT_SDK_LICENSE_KEY>",
    storageImageFormat: StorageImageFormat.JPG,
    storageImageQuality: 80,
  );

  await ScanbotSdk.initialize(config);
}
