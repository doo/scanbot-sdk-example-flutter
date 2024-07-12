import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

void itemMappingConfigSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();

  // Initialize the use case for single scanning.
  var scanningMode = MultipleScanningMode();

  // Set the item mapper.
  scanningMode.barcodeInfoMapping.barcodeItemMapper =
      (item, onResult, onError) async {
    /** TODO: process scan result as needed to get your mapped data,
     * e.g. query your server to get product image, title and subtitle.
     * See example below.
     */
    var title = "Some product ${item.textWithExtension}";
    var subtitle = item.type?.name ?? "Unknown";
    var image =
        "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png";

    /** TODO: call [onError()] in case of error during obtaining mapped data. */
    if (item.textWithExtension == "Error occurred!") {
      onError();
    } else {
      onResult(BarcodeMappedData(
        title: title,
        subtitle: subtitle,
        barcodeImage: image,
      ));
    }

    configuration.useCase = scanningMode;

    // Configure other parameters as needed.
  };
}
