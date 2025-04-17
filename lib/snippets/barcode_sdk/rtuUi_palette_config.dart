import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

BarcodeScannerScreenConfiguration rtuUiPaletteConfig() {
  // Create the default configuration object.
  var config = BarcodeScannerScreenConfiguration();

  // Simply alter one color and keep the other default.
  config.palette.sbColorPrimary = ScanbotColor('c86e19');

  // ... or set an entirely new palette.
  config.palette.sbColorPrimary = ScanbotColor('#C8193C');
  config.palette.sbColorPrimaryDisabled = ScanbotColor('#F5F5F5');
  config.palette.sbColorNegative = ScanbotColor('#FF3737');
  config.palette.sbColorPositive = ScanbotColor('#4EFFB4');
  config.palette.sbColorWarning = ScanbotColor('#FFCE5C');
  config.palette.sbColorSecondary = ScanbotColor('#FFEDEE');
  config.palette.sbColorSecondaryDisabled = ScanbotColor('#F5F5F5');
  config.palette.sbColorOnPrimary = ScanbotColor('#FFFFFF');
  config.palette.sbColorOnSecondary = ScanbotColor('#C8193C');
  config.palette.sbColorSurface = ScanbotColor('#FFFFFF');
  config.palette.sbColorOutline = ScanbotColor('#EFEFEF');
  config.palette.sbColorOnSurfaceVariant = ScanbotColor('#707070');
  config.palette.sbColorOnSurface = ScanbotColor('#000000');
  config.palette.sbColorSurfaceLow = ScanbotColor('#00000026');
  config.palette.sbColorSurfaceHigh = ScanbotColor('#0000007A');
  config.palette.sbColorModalOverlay = ScanbotColor('#000000A3');

  return config;
}

Future<void> runBarcodeScanner() async {
  var configuration = rtuUiPaletteConfig();
  var result = await ScanbotSdkUiV2.startBarcodeScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // TODO: present barcode result as needed
  }
}