import 'package:flutter/material.dart' show Colors;
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> croppingScreen(Page page) async{
  var configuration = CroppingScreenConfiguration(
      doneButtonTitle: 'Apply',
      topBarBackgroundColor: Colors.white,
      bottomBarBackgroundColor: Colors.white,
    );

  var pageResult = await ScanbotSdkUi.startCroppingScreen(page, configuration);
}