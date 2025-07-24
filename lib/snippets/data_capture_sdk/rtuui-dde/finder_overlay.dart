import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = DocumentDataExtractorScreenConfiguration();
  // Configure the view finder.
  // Set the style for the view finder.
  // Choose between cornered or stroked style.
  // For default stroked style.
  configuration.viewFinder.style = FinderStyle.finderStrokedStyle();
  // For default cornered style.
  configuration.viewFinder.style = FinderStyle.finderCorneredStyle();
  // You can also set each style's stroke width, stroke color or corner radius.
  // e.g
  configuration.viewFinder.style = FinderCorneredStyle(strokeWidth: 3.0);

  // Start the DDE
  var result = await ScanbotSdkUiV2.startDocumentDataExtractor(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}