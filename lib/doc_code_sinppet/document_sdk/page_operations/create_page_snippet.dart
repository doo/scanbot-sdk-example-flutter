import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> _createPage(Uri uri) async {
  // Create a Scanbot page with immediate document detection
  // shouldDetectDocument: true
  var page = await ScanbotSdk.createPage(uri, true); 
}