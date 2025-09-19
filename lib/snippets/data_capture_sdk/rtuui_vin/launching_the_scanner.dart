import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = VinScannerScreenConfiguration();
  /** Start the VIN Scanner **/
  var result = await ScanbotSdkUiV2.startVINScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}