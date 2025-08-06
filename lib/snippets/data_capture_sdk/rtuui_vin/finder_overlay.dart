import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = VinScannerScreenConfiguration();
  //** Configure the view finder style */
  configuration.viewFinder.style = FinderCorneredStyle(
    cornerRadius: 8,
    strokeWidth: 2,
  );
  /** Start the VIN Scanner **/
  var result = await ScanbotSdkUiV2.startVINScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}