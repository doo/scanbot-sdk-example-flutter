import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration **/
  final configuration = TextPatternScannerScreenConfiguration();

  /** Retrieve the instance of the viewFinder from the configuration object **/
  final viewFinder = configuration.viewFinder;

  /** Configure the view finder.
   * Choose between cornered or stroked style. **/

  /** Stroked style **/
  viewFinder.style = FinderStrokedStyle();

  /** Cornered style **/
  viewFinder.style = FinderCorneredStyle();

  /** Cornered style with custom stroke width and color **/
  viewFinder.style = FinderCorneredStyle(
    strokeWidth: 3,
    strokeColor: ScanbotColor('#ff0000'),
  );

  /** Start the Text Pattern Scanner **/
  final textPatternResult =
      await ScanbotSdk.textPattern.startScanner(configuration);

  if (textPatternResult is Ok<TextPatternScannerUiResult>) {
    /** Handle the result **/
    var scannerUiResult = textPatternResult.value;
    print(scannerUiResult.toString());
  } else {
    print(textPatternResult.toString());
  }
}
