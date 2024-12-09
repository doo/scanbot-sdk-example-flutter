import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  /** Create the default configuration instance */
  var configuration = DocumentScanningFlow();
  /** Set any `ParametricFilter` type to default filter.*/
  configuration.outputSettings.defaultFilter = ScanbotBinarizationFilter();
  /** Start the Document Scanner UI */
  var documentResult = await ScanbotSdkUiV2.startDocumentScanner(configuration);
  /** Handle the document if the status is 'OK' */
  if (documentResult.status == OperationStatus.OK) {
  }
}