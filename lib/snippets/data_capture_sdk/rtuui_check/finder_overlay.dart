import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = CheckScannerScreenConfiguration();
  // Set the overlay color
  configuration.viewFinder.overlayColor = ScanbotColor('#C8193C');
  // Configure the aspect ratio of the view finder
  configuration.viewFinder.aspectRatio = AspectRatio(
    width: 8,
    height: 6,
  );
  // Configure the view finder style
  configuration.viewFinder.style = FinderCorneredStyle(
    cornerRadius: 8,
    strokeWidth: 2,
  );
  // Start the Check Scanner
  var result = await ScanbotSdk.check.startScanner(configuration);
  if (result is Ok<CheckScannerUiResult>) {
    /** Handle the result **/
    var scannerUiResult = result.value;
  }
}
