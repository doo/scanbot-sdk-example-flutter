import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = CheckScannerScreenConfiguration();
  // Start the Check Scanner
  var result = await ScanbotSdk.check.startScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}
