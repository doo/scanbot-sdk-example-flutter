import 'dart:math';

import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as scanbot_sdk;

BatchBarcodeScannerConfiguration batchBarcodeConfigurationSnippet() {
  return BatchBarcodeScannerConfiguration(
    barcodeFormatter: _barcodeFormatter,
    cancelButtonTitle: 'Cancel',
    enableCameraButtonTitle: 'Camera Enable',
    enableCameraExplanationText: 'Explanation text',
    finderTextHint:
    'Please align any supported barcode in the frame to scan it.',
    // clearButtonTitle: "CCCClear", // Uncomment if needed to provide clear button text
    // submitButtonTitle: "Submitt", // Uncomment if needed to provide submit button text
    barcodesCountText: '%d codes',
    fetchingStateText: 'Might be not needed',
    noBarcodesTitle: 'Nothing to see here',
    finderAspectRatio: scanbot_sdk.AspectRatio(width: 3, height: 2), // Aspect ratio of the scanning frame
    finderLineWidth: 7,
    successBeepEnabled: true,
    orientationLockMode: OrientationLockMode.PORTRAIT,
    barcodeFormats: PredefinedBarcodes.allBarcodeTypes(),
    cancelButtonHidden: false,
    // cameraZoomFactor: 0.5 // Uncomment and set zoom factor if needed
    /*additionalParameters: BarcodeAdditionalParameters(
          enableGS1Decoding: false,
          minimumTextLength: 10,
          maximumTextLength: 11,
          minimum1DBarcodesQuietZone: 10,
        )*/ // Uncomment to set additional barcode parameters
  );
}

/// Formats the barcode data with a random delay
Future<BarcodeFormattedData> _barcodeFormatter(BarcodeItem item) async {
  final random = Random();
  final randomNumber = random.nextInt(4) + 2;
  await Future.delayed(Duration(seconds: randomNumber));

  return BarcodeFormattedData(
    title: item.barcodeFormat.toString(),
    subtitle: '${item.text ?? ''} custom string',
  );
}
