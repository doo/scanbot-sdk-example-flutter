import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

BarcodeScannerConfiguration singleScanningUseCaseSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();
  // Configure parameters (use explicit `this.` receiver for better code completion):

  // Initialize the use case for single scanning.
  var scanningMode = SingleScanningMode();
  // Enable and configure the confirmation sheet.
  scanningMode.confirmationSheetEnabled = true;
  scanningMode.sheetColor = ScanbotColor("#FFFFFF");

  // Hide/unhide the barcode image.
  scanningMode.barcodeImageVisible = true;

  // Configure the barcode title of the confirmation sheet.
  scanningMode.barcodeTitle.visible = true;
  scanningMode.barcodeTitle.color = ScanbotColor("#000000");

  // Configure the barcode subtitle of the confirmation sheet.
  scanningMode.barcodeSubtitle.visible = true;
  scanningMode.barcodeSubtitle.color = ScanbotColor("#000000");

  // Configure the cancel button of the confirmation sheet.
  scanningMode.cancelButton.text = "Close";
  scanningMode.cancelButton.foreground.color = ScanbotColor("#C8193C");
  scanningMode.cancelButton.background.fillColor = ScanbotColor("#00000000");

  // Configure the submit button of the confirmation sheet.
  scanningMode.submitButton.text = "Submit";
  scanningMode.submitButton.foreground.color = ScanbotColor("#FFFFFF");
  scanningMode.submitButton.background.fillColor = ScanbotColor("#C8193C");

  // Configure other parameters, pertaining to single-scanning mode as needed.

  configuration.useCase = scanningMode;

  // Set an array of accepted barcode types.
  // configuration.recognizerConfiguration.barcodeFormats = [
  //   BarcodeFormat.AZTEC,
  //   BarcodeFormat.PDF_417,
  //   BarcodeFormat.QR_CODE,
  //   BarcodeFormat.MICRO_QR_CODE,
  //   BarcodeFormat.MICRO_PDF_417,
  //   BarcodeFormat.ROYAL_MAIL,
  ///  .....
  // ];

  // Configure other parameters as needed.

  return configuration;
}

Future<void> runBarcodeScanner() async {
  var configuration = singleScanningUseCaseSnippet();
  var result = await ScanbotSdkUi.startBarcodeScanner(configuration);
  if (result.operationResult == OperationResult.SUCCESS) {
    // TODO: present barcode result as needed
  }
}
