import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create an instance of the default configuration */
  var configuration = CreditCardScannerScreenConfiguration();
  /** Retrieve the instance of the top user guidance from the configuration object. */
  var topUserGuidance = configuration.topUserGuidance;
  /** Show the top user guidance */
  topUserGuidance.visible = true;
  /** Customize the top user guidance */
  topUserGuidance.title.text = 'Customized title';
  topUserGuidance.title.color = ScanbotColor('#000000');
  /** Customize the top user guidance background */
  topUserGuidance.background.fillColor = ScanbotColor('#C8193C');
  /** Retrieve the instance of the scan status user guidance from the configuration object. */
  var scanStatusUserGuidance = configuration.scanStatusUserGuidance;
  /** Customize the scan status user guidance */
  scanStatusUserGuidance.statesTitles.noCardFound = 'No card found.';
  scanStatusUserGuidance.statesTitles.scanningProgress = 'Scanning...';
  /** Customize the status user guidance text */
  scanStatusUserGuidance.title.text = 'Customized title';
  scanStatusUserGuidance.title.color = ScanbotColor('#000000');
  /** Customize the status user guidance background */
  scanStatusUserGuidance.background.fillColor = ScanbotColor('#C8193C');
  /** Start the Credit Card Scanner **/
  var result = await ScanbotSdkUiV2.startCreditCardScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}