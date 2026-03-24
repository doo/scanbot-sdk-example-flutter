import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> initialize() async {
  var config = SdkConfiguration(
    licenseKey: "<YOUR_SCANBOT_SDK_LICENSE_KEY>",
    loggingEnabled: true,
  );

  await ScanbotSdk.initialize(config);
}
