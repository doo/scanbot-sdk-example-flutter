import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = MrzScannerScreenConfiguration();
  /** Configure the top bar mode */
  configuration.topBar.mode = TopBarMode.SOLID;
  /** Configure the top bar background color */
  configuration.topBar.backgroundColor = ScanbotColor('#C8193C');
  /** Configure the top bar status bar mode */
  configuration.topBar.statusBarMode = StatusBarMode.LIGHT;
  /** Configure the cancel button */
  configuration.topBar.cancelButton.text = 'Cancel';
  configuration.topBar.cancelButton.foreground.color = ScanbotColor('#FFFFFF');
  /** Start the MRZ Scanner UI */
  var result = await ScanbotSdk.mrz.startScanner(configuration);
  if (result is Ok<MrzScannerUiResult>) {
    /** Handle the result **/
    var scannerUiResult = result.value;
    // Display the parsed MRZ fields, e.g. document number and birth date.
  } else {
    // Handle the error or cancellation, e.g. show a message to the user.
  }
}
