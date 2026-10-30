import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  /** Create the default configuration instance */
  var configuration = DocumentScanningFlow();
  /** Set any `ParametricFilter` type to default filter.*/
  configuration.outputSettings.defaultFilter = ScanbotBinarizationFilter();
  /** Start the Document Scanner UI */
  var documentResult = await ScanbotSdk.document.startScanner(configuration);
  /** Handle the document if the result is 'Ok' */
  if (documentResult is Ok<DocumentData>) {
    var documentData = documentResult.value;
    // Display the scanned pages, or export the document as PDF/TIFF.
  } else {
    // Handle the error or cancellation, e.g. show a message to the user.
  }
}
