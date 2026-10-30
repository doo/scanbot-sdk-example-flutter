import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = DocumentDataExtractorScreenConfiguration();
  /** Configure the top bar mode */
  configuration.topBar.mode = TopBarMode.SOLID;
  /** Configure the top bar background color */
  configuration.topBar.backgroundColor = ScanbotColor('#C8193C');
  /** Configure the top bar status bar mode */
  configuration.topBar.statusBarMode = StatusBarMode.LIGHT;
  /** Configure the cancel button */
  configuration.topBar.cancelButton.text = 'Cancel';
  configuration.topBar.cancelButton.foreground.color = ScanbotColor('#FFFFFF');
  /** Start the DDE **/
  var result = await ScanbotSdk.documentDataExtractor.startExtractorScreen(
    configuration,
  );
  if (result is Ok<DocumentDataExtractorUiResult>) {
    /** Handle the result **/
    var documentDataExtractorUiResult = result.value;
    // Display the extracted document fields, e.g. name and birth date.
  } else {
    // Handle the error, e.g. show a message to the user.
  }
}
