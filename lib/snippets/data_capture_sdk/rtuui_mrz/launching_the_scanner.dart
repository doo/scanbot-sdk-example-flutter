import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = MrzScannerScreenConfiguration();
  /** Start the MRZ Scanner **/
  var result = await ScanbotSdkUiV2.startMrzScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}