import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = TextPatternScannerScreenConfiguration();
  /** Start the Text Pattern Scanner **/
  var result = await ScanbotSdkUiV2.startTextDataScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}