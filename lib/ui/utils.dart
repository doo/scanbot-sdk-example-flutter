import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

class Utils {
  static const MethodChannel _channel = const MethodChannel('utils');

  static Future<Uri> pickImage() async {
    try {
      var arguments = {};
      String uriString = await _channel.invokeMethod("pickImage", arguments);
      return Uri.parse(uriString);
    } catch (e) {
      return null;
    }
  }
}

Future<void> showAlertDialog(BuildContext context, String textToShow, {String title}) async {
  Widget text = SimpleDialogOption(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(textToShow),
    ),
  );

  // set up the SimpleDialog
  AlertDialog dialog = AlertDialog(
    title: title != null ? Text(title) : null,
    content: text,
    contentPadding: EdgeInsets.all(0),
    actions: <Widget>[
      FlatButton(
        child: Text('OK'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );

  // show the dialog
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}

Future<bool> checkLicenseStatus(BuildContext context) async {
  var result = await ScanbotSdk.getLicenseStatus();
  if (result.isLicenseValid) {
    return true;
  }
  await showAlertDialog(context, 'Scanbot SDK (trial) period or license has expired.', title: 'Info');
  return false;
}
