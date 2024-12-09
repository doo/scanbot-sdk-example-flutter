import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

BarcodeScannerConfiguration singleScanningUseCaseSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();
  // Configure parameters (use explicit `this.` receiver for better code completion):


  // Set an array of accepted barcode types.
  configuration.recognizerConfiguration.barcodeFormats = [BarcodeFormat.RMQR_CODE, BarcodeFormat.MAXI_CODE, BarcodeFormat.CODE_11, BarcodeFormat.CODE_32, BarcodeFormat.DATA_MATRIX];

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
  var result = await ScanbotSdkUiV2.startBarcodeScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // TODO: present barcode result as needed
  }
}
