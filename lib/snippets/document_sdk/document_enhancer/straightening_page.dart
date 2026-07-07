import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> straightenDocument(
  String pageUuid,
  String documentUuid,
) async {
  final straighteningParameters = DocumentStraighteningParameters()
    // Configure the straightening mode as needed
    ..straighteningMode = DocumentStraighteningMode.STRAIGHTEN

    // The straightening parameters can be customized to fit the expected aspect ratio of the document to be straightened.
    // This can help the straightening algorithm to achieve better results.
    ..aspectRatios = [
      AspectRatio(width: 5, height: 7),
      AspectRatio(width: 1, height: 1),
      AspectRatio(width: 16, height: 9),
      AspectRatio(width: 3, height: 4),
    ];

  final documentResult = await ScanbotSdk.document.modifyPage(
    documentUuid,
    pageUuid,
    options: ModifyPageOptions(
      straighteningParameters: straighteningParameters,
    ),
  );

  if (documentResult is Ok<DocumentData>) {
    // Handle the modified document result
    final modifiedPage = documentResult.value.pages
        .where((page) => page.uuid == pageUuid)
        .firstOrNull;
    print(modifiedPage);
  } else {
    print(documentResult.toString());
  }
}
