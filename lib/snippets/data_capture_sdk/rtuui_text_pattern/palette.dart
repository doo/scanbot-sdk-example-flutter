import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = TextPatternScannerScreenConfiguration();
  /** Configure the colors. */
  var palette = configuration.palette;
  /** The palette already has the default colors set, so you don't have to always set all the colors. */
  palette.sbColorPrimary = ScanbotColor('#C8193C');
  palette.sbColorPrimaryDisabled = ScanbotColor('#F5F5F5');
  palette.sbColorNegative = ScanbotColor('#FF3737');
  palette.sbColorPositive = ScanbotColor('#4EFFB4');
  palette.sbColorWarning = ScanbotColor('#FFCE5C');
  palette.sbColorSecondary = ScanbotColor('#FFEDEE');
  palette.sbColorSecondaryDisabled = ScanbotColor('#F5F5F5');
  palette.sbColorOnPrimary = ScanbotColor('#FFFFFF');
  palette.sbColorOnSecondary = ScanbotColor('#C8193C');
  palette.sbColorSurface = ScanbotColor('#FFFFFF');
  palette.sbColorOutline = ScanbotColor('#EFEFEF');
  palette.sbColorOnSurfaceVariant = ScanbotColor('#707070');
  palette.sbColorOnSurface = ScanbotColor('#000000');
  palette.sbColorSurfaceLow = ScanbotColor('#26000000');
  palette.sbColorSurfaceHigh = ScanbotColor('#7A000000');
  palette.sbColorModalOverlay = ScanbotColor('#A3000000');
  /** Start the Text Pattern Scanner **/
  var result = await ScanbotSdk.textPattern.startScanner(configuration);
  if (result is Ok<TextPatternScannerUiResult>) {
    /** Handle the result **/
    var scannerUiResult = result.value;
    // Use the recognized text, e.g. display it or fill in a form field.
  } else {
    // Handle the error or cancellation, e.g. show a message to the user.
  }
}
