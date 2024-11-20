import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

BarcodeScannerConfiguration itemMappingConfigSnippet() {
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
        "https://avatars.githubusercontent.com/u/1454920";

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
  };

  // Retrieve the instance of the error state from the use case object.
  var errorState = scanningMode.barcodeInfoMapping.errorState;

  // Configure the title.
  errorState.title.text = "Error_Title";
  errorState.title.color = ScanbotColor("#000000");

  // Configure the subtitle.
  errorState.subtitle.text = "Error_Subtitle";
  errorState.subtitle.color = ScanbotColor("#000000");

  // Configure the cancel button.
  errorState.cancelButton.text = "Cancel";
  errorState.cancelButton.foreground.color = ScanbotColor("#C8193C");

  // Configure the retry button.
  errorState.retryButton.text = "Retry";
  errorState.retryButton.foreground.iconVisible = true;
  errorState.retryButton.foreground.color = ScanbotColor("#FFFFFF");
  errorState.retryButton.background.fillColor = ScanbotColor("#C8193C");

  // Set the configured error state.
  scanningMode.barcodeInfoMapping.errorState = errorState;

  // Set the configured use case.
  configuration.useCase = scanningMode;

  // Create and set an array of accepted barcode formats.
  // configuration.recognizerConfiguration.barcodeFormats = [
  //   BarcodeFormat.AZTEC,
  //   BarcodeFormat.PDF_417,
  //   BarcodeFormat.QR_CODE,
  //   BarcodeFormat.MICRO_QR_CODE,
  //   BarcodeFormat.MICRO_PDF_417,
  //   BarcodeFormat.ROYAL_MAIL,
  // ];

  // Configure other parameters as needed.

  return configuration;
}

Future<void> runBarcodeScanner() async {
  var configuration = itemMappingConfigSnippet();
  var result = await ScanbotSdkUi.startBarcodeScanner(configuration);
  if (result.operationResult == OperationResult.SUCCESS) {
    // TODO: present barcode result as needed
  }
}
