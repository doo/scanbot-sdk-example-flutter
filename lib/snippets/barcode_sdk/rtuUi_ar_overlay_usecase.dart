import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

BarcodeScannerScreenConfiguration rtuUiArOverlayUseCase() {
  // Create the default configuration object.
  var configuration = BarcodeScannerScreenConfiguration();

  // Initialize the use case for multiple scanning.
  var scanningMode = MultipleScanningMode();

  scanningMode.mode = MultipleBarcodesScanningMode.UNIQUE;
  scanningMode.sheet.mode = SheetMode.COLLAPSED_SHEET;
  scanningMode.sheet.collapsedVisibleHeight = CollapsedVisibleHeight.SMALL;
  // Configure AR Overlay.
  scanningMode.arOverlay.visible = true;
  scanningMode.arOverlay.automaticSelectionEnabled = false;

  configuration.useCase = scanningMode;

  // Configure other parameters as needed.

  return configuration;
}


Future<void> runBarcodeScanner() async {
  var configuration = rtuUiArOverlayUseCase();
  var result = await ScanbotSdkUiV2.startBarcodeScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // TODO: present barcode result as needed
  }
}