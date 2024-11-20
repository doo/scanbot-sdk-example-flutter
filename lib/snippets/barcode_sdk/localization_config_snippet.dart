import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

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
  var result = await ScanbotSdkUi.startBarcodeScanner(configuration);
  if (result.operationResult == OperationResult.SUCCESS) {
    // TODO: present barcode result as needed
  }
}
