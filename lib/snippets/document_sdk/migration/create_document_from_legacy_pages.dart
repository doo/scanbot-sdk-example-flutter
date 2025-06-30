import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> createDocumentWithLegacyPages(List<Page> pages) async {
  /**
   * Create a document with a UUID
   * Add pages to the document from 'legacy' pages
   */
  var params = DocumentFromLegacyPagesParams(pages: pages);
  var documentData = await ScanbotSdk.document.createDocumentFromLegacyPages(params);
  /**
   * Now you may delete the files corresponding to the Page to free up storage.
   * Use ScanbotSDK.removePage(page) to remove the old pages
   */
}