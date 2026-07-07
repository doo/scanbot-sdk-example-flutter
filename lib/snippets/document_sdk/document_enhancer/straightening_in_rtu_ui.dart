import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> straightenDocument() async {
  final configuration = DocumentScanningFlow();
  final straighteningParameters =
      configuration.outputSettings.straighteningParameters;

  // Configure the straightening mode as needed
  straighteningParameters.straighteningMode =
      DocumentStraighteningMode.STRAIGHTEN;

  // The straightening parameters can be customized to fit the expected aspect ratio of the document to be straightened.
  // This can help the straightening algorithm to achieve better results.
  straighteningParameters.aspectRatios = [
    AspectRatio(width: 5, height: 7),
    AspectRatio(width: 1, height: 1),
    AspectRatio(width: 16, height: 9),
    AspectRatio(width: 3, height: 4),
  ];

  final documentResult = await ScanbotSdk.document.startScanner(configuration);

  if (documentResult is Ok<DocumentData>) {
    // Handle the document result
    var documentData = documentResult.value;
    print(documentData);
  } else {
    print(documentResult.toString());
  }
}
