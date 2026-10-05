import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = MrzScannerScreenConfiguration();
  // Start the MRZ Scanner
  var result = await ScanbotSdk.mrz.startScanner(configuration);
  if (result is Ok<MrzScannerUiResult>) {
    // Cast the resulted generic document to the MRZ model.
    var mrzModel = MRZ(result.value.mrzDocument!);
    // Retrieve the values, e.g. to fill in a form.
    // Each field also provides a `confidence` value.
    var birthDate = mrzModel.birthDate.value?.text;
    var nationality = mrzModel.nationality?.value?.text;
  } else {
    // Handle the error or cancellation, e.g. show a message to the user.
  }
}
