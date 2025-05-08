import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

BarcodeScannerScreenConfiguration rtuUiMappingItemConfiguration() {
  // Create the default configuration object.
  var configuration = BarcodeScannerScreenConfiguration();

  // Initialize the use case for single scanning.
  var scanningMode = MultipleScanningMode();

  // Set the item mapper.
  scanningMode.barcodeInfoMapping.barcodeItemMapper =
      (item, onResult, onError) async {
    /** TODO: process scan result as needed to get your mapped data,
     * e.g. query your server to get product image, title and subtitle.
     * See example below.
     */
    var title = "Some product ${item.text}";
    var subtitle = item.format.name ?? "Unknown";
    var image =
        "https://avatars.githubusercontent.com/u/1454920";

    /** TODO: call [onError()] in case of error during obtaining mapped data. */
    if (item.text == "Error occurred!") {
      onError();
    } else {
      onResult(BarcodeMappedData(
        title: title,
        subtitle: subtitle,
        barcodeImage: image,
      ));
    }
  };

  configuration.useCase = scanningMode;

  // Configure other parameters as needed.

  return configuration;
}

Future<void> runBarcodeScanner() async {
  var configuration = rtuUiMappingItemConfiguration();
  var result = await ScanbotSdkUiV2.startBarcodeScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // TODO: present barcode result as needed
  }
}
