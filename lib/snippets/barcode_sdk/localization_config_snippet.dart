import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

BarcodeScannerConfiguration configurationWithLocalizationSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();
  // Configure localization parameters.

  configuration.localization.barcodeInfoMappingErrorStateCancelButton =
      "Custom Cancel title";
  configuration.localization.cameraPermissionCloseButton = "Custom Close title";

  // Configure other strings as needed.

  // Configure other parameters as needed.

  return configuration;
}

Future<void> runBarcodeScanner() async {
  var configuration = configurationWithLocalizationSnippet();
  var result = await ScanbotSdkUiV2.startBarcodeScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // TODO: present barcode result as needed
  }
}
