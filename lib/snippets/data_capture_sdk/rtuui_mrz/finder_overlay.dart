import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = MrzScannerScreenConfiguration();
  /** Hide the example overlay  */
  configuration.mrzExampleOverlay = NoLayoutPreset();
  /** Configure the example overlay  */
  configuration.mrzExampleOverlay = ThreeLineMrzFinderLayoutPreset(
    mrzTextLine1: 'I<USA2342353464<<<<<<<<<<<<<<<',
    mrzTextLine2: '9602300M2904076USA<<<<<<<<<<<2',
    mrzTextLine3: 'SMITH<<JACK<<<<<<<<<<<<<<<<<<<',
  );
  //** Configure the view finder style */
  configuration.viewFinder.style = FinderCorneredStyle(
    cornerRadius: 8,
    strokeWidth: 2,
  );
  /** Start the MRZ Scanner UI */
  var result = await ScanbotSdkUiV2.startMrzScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}