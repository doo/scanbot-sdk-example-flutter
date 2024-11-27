import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

BarcodeScannerConfiguration AROverlayUsecaseSnippet() {
// Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();

  // Configure the usecase.
  var useCase = MultipleScanningMode();

  useCase.mode = MultipleBarcodesScanningMode.UNIQUE;

  // Set the sheet mode for the barcodes preview.
  useCase.sheet.mode = SheetMode.COLLAPSED_SHEET;

  // Set the height for the collapsed sheet.
  useCase.sheet.collapsedVisibleHeight = CollapsedVisibleHeight.SMALL;

  // Configure AR Overlay.
  useCase.arOverlay.visible = true;
  useCase.arOverlay.automaticSelectionEnabled = false;

  // Create and set an array of accepted barcode formats.
  // configuration.recognizerConfiguration.barcodeFormats = [
  //   BarcodeFormat.AZTEC,
  //   BarcodeFormat.PDF_417,
  //   BarcodeFormat.QR_CODE,
  //   BarcodeFormat.MICRO_QR_CODE,
  //   BarcodeFormat.MICRO_PDF_417,
  //   BarcodeFormat.ROYAL_MAIL,
  // ];

  // Set the configured usecase.
  configuration.useCase = useCase;

  // Configure other parameters, pertaining to use case as needed.

  // Configure other parameters as needed.

  return configuration;
}

Future<void> runBarcodeScanner() async {
  var configuration = AROverlayUsecaseSnippet();
  var result = await ScanbotSdkUi.startBarcodeScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // TODO: present barcode result as needed
  }
}