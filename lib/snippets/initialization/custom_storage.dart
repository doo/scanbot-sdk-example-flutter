import 'package:path_provider/path_provider.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> initialize() async {
  var directory = await getApplicationSupportDirectory();
  var storageBaseDirectory = '${directory.path}/my-custom-storage';

  var config = SdkConfiguration(
    licenseKey: "<YOUR_SCANBOT_SDK_LICENSE_KEY>",
    storageBaseDirectory: storageBaseDirectory,
  );

  await ScanbotSdk.initialize(config);
}
