import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> applyFiltersAndRotateScannedPage() async {
  /** Load a document from storage or create a new one */
  var documentResult = await ScanbotSdk.document.loadDocument(
    "SOME_STORED_DOCUMENT_ID",
  );

  if (documentResult is Ok<DocumentData>) {
    var document = documentResult.value;

    /** Get the first page of the document */
    var page = document.pages[0];
    /**
     * Apply ScanbotBinarizationFilter to the page
     * Rotate the page clockwise by 90 degrees
     */
    var options = ModifyPageOptions(
        filters: [ScanbotBinarizationFilter()],
        rotation: ImageRotation.CLOCKWISE_90);
    var documentResultWithModifiedPage = await ScanbotSdk.document
        .modifyPage(document.uuid, page.uuid, options: options);
    if (documentResultWithModifiedPage is Ok<DocumentData>) {
      /** Handle the document */
    } else {
      print(documentResultWithModifiedPage.toString());
    }
  } else {
    print(documentResult.toString());
  }
}
