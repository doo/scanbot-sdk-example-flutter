import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> croppingScreen(String documentID, String pageID) async {
  var configuration = CroppingConfiguration(
    documentUuid: documentID,
    pageUuid: pageID,
  );
  // Equivalent to topBarBackgroundColor & bottomBarBackgroundColor: '#ffffff'
  configuration.palette.sbColorPrimary = ScanbotColor('#ffffff');
  // Equivalent to doneButtonTitle: 'Apply',
  configuration.localization.croppingTopBarConfirmButtonTitle = 'Apply';

  var documentData = await ScanbotSdk.document.startCroppingScreen(configuration);
}