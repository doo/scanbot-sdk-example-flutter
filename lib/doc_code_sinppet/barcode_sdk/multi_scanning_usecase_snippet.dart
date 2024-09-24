import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

void multipleScanningUseCaseSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();

  // Initialize the use case for multiple scanning.
  var scanningMode = MultipleScanningMode();

  // Set the counting mode.
  scanningMode.mode = MultipleBarcodesScanningMode.COUNTING;

  // Set the sheet mode for the barcodes preview.
  scanningMode.sheet.mode = SheetMode.COLLAPSED_SHEET;

  // Set the height for the collapsed sheet.
  scanningMode.sheet.collapsedVisibleHeight = CollapsedVisibleHeight.LARGE;

  // Enable manual count change.
  scanningMode.sheetContent.manualCountChangeEnabled = true;

  // Set the delay before same barcode counting repeat.
  scanningMode.countingRepeatDelay = 1000;

  // Configure the submit button.
  scanningMode.sheetContent.submitButton.text = "Submit";
  scanningMode.sheetContent.submitButton.foreground.color =
      ScanbotColor("#000000");

  // Configure other parameters, pertaining to multiple-scanning mode as needed.

  configuration.useCase = scanningMode;

  // Set an array of accepted barcode types.
  // configuration.recognizerConfiguration.barcodeFormats = [
  //   scanbotV2.BarcodeFormat.AZTEC,
  //   scanbotV2.BarcodeFormat.PDF_417,
  //   scanbotV2.BarcodeFormat.QR_CODE,
  //   scanbotV2.BarcodeFormat.MICRO_QR_CODE,
  //   scanbotV2.BarcodeFormat.MICRO_PDF_417,
  //   scanbotV2.BarcodeFormat.ROYAL_MAIL,
  ///  .....
  // ];

  // Configure other parameters as needed.
}
