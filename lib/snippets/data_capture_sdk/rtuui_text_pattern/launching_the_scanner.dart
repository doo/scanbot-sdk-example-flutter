import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = TextPatternScannerScreenConfiguration();
  /** Start the Text Pattern Scanner **/
  var result = await ScanbotSdk.textPattern.startScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}