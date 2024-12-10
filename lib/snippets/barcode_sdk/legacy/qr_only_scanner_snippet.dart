import 'package:scanbot_sdk/scanbot_sdk.dart';

BarcodeScannerConfiguration QROnlyBarcodeConfigurationSnippet() {
  return BarcodeScannerConfiguration(
    barcodeFormats: [BarcodeFormat.QR_CODE],
    finderTextHint: 'Please align a QR code in the frame to scan it.',
    /*  additionalParameters: BarcodeAdditionalParameters(
          enableGS1Decoding: false,
          minimumTextLength: 10,
          maximumTextLength: 11,
          minimum1DBarcodesQuietZone: 10,
        )*/
    // ...
  );
}