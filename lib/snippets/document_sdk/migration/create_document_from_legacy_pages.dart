import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createDocumentWithLegacyPages(List<Page> pages) async {
  /**
   * Create a document with a UUID
   * Add pages to the document from 'legacy' pages
   */
  var documentResult = await ScanbotSdk.document.createDocumentFromLegacyPages(
    pages,
  );
  if (documentResult is Ok<DocumentData>) {
    var documentData = documentResult.value;
    print(documentData);
  } else {
    print(documentResult.toString());
  }
  /**
   * Now you may delete the files corresponding to the Page to free up storage.
   * Use ScanbotSdk.legacyPage.removePage(page) or ScanbotSdk.legacyPage.removeAllPages() to remove the old pages
   */
}
