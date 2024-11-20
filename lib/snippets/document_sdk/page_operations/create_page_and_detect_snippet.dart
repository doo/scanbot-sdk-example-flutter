import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> _createPage(Uri uri) async {
  // Create a Scanbot page without immediate document detection
  // shouldDetectDocument: false
  var page = await ScanbotSdk.createPage(uri, false);

  // ...

  // Perform document detection later
  page = await ScanbotSdk.detectDocument(page);
}