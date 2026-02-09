import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = MrzScannerScreenConfiguration();
  /** Configure the top bar mode */
  configuration.topBar.mode = TopBarMode.GRADIENT;
  /** Configure the top bar status bar mode */
  configuration.topBar.statusBarMode = StatusBarMode.LIGHT;
  /** Configure the top bar background color */
  configuration.topBar.cancelButton.text = 'Cancel';
  configuration.topBar.cancelButton.foreground.color = ScanbotColor('#C8193C');
  /** Start the MRZ Scanner UI */
  var result = await ScanbotSdk.mrz.startScanner(configuration);
  if (result is Ok<MrzScannerUiResult>) {
    /** Handle the result **/
    var scannerUiResult = result.value;
    print(scannerUiResult.toString());
  } else {
    print(result.toString());
  }
}
