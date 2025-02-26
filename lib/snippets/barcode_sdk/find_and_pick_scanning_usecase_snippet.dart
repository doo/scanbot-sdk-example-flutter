import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

BarcodeScannerConfiguration findAndPickModeUseCaseSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();

  // Initialize the use case for find and pick scanning.
  var scanningMode = FindAndPickScanningMode();

  // Set the sheet mode for the barcodes preview.
  scanningMode.sheet.mode = SheetMode.COLLAPSED_SHEET;

  // Enable the AR Overlay
  scanningMode.arOverlay.visible = true;

  // Enable/Disable the automatic selection.
  scanningMode.arOverlay.automaticSelectionEnabled = false;

  // Set the height for the collapsed sheet.
  scanningMode.sheet.collapsedVisibleHeight = CollapsedVisibleHeight.LARGE;

  // Enable manual count change.
  scanningMode.sheetContent.manualCountChangeEnabled = true;

  // Set the delay before same barcode counting repeat.
  scanningMode.countingRepeatDelay = 1000;

  // Configure the submit button.
  scanningMode.sheetContent.submitButton.text = "Submit";
  scanningMode.sheetContent.submitButton.foreground.color = ScanbotColor("#000000");

  // Configure other parameters, pertaining to findAndPick-scanning mode as needed.
  // Set the expected barcodes.
  scanningMode.expectedBarcodes = [
    ExpectedBarcode(
        barcodeValue: "123456",
        title: "numeric barcode",
        image:
            "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png",
        count: 4),
    ExpectedBarcode(
        barcodeValue: "SCANBOT",
        title: "value barcode",
        image:
            "https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png",
        count: 3)
  ];

  configuration.useCase = scanningMode;

  // Configure other parameters as needed.

  return configuration;
}

Future<void> runBarcodeScanner() async {
  var configuration = findAndPickModeUseCaseSnippet();
  var result = await ScanbotSdkUiV2.startBarcodeScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // TODO: present barcode result as needed
  }
}