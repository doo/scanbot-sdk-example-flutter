import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = MrzScannerScreenConfiguration();
  // Start the MRZ Scanner
  var result = await ScanbotSdkUiV2.startMrzScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // Cast the resulted generic document to the MRZ model.
    var mrzModel = MRZ(result.data!.mrzDocument!);
    // Retrieve the values.
    // e.g
    print('Birth date: ${mrzModel.birthDate.value?.text}, Confidence: ${mrzModel.birthDate.value?.confidence}');
    print('Nationality: ${mrzModel.nationality.value?.text}, Confidence: ${mrzModel.nationality.value?.confidence}');
  }
}