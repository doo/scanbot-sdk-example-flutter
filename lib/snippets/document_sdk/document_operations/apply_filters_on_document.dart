import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> applyFiltersAndRotateScannedPage() async {
  /** Load a document from storage or create a new one */
  var document = await ScanbotSdk.document.loadDocument(
    "SOME_STORED_DOCUMENT_ID",
  );

  /** Get the first page of the document */
  var page = document.value!.pages[0];
  /**
   * Apply ScanbotBinarizationFilter to the page
   * Rotate the page clockwise by 90 degrees
   */
  var params = ModifyPageParams(
    documentID: document.value!.uuid,
    pageID: page.uuid,
    filters: [ScanbotBinarizationFilter()],
    rotation: PageRotation.CLOCKWISE_90
  );
  var documentResultWithModifiedPage = await ScanbotSdk.document.modifyPage(params);
  /** Handle the document */
}