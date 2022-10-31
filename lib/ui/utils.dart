import 'package:flutter/material.dart';
import 'package:scanbot_sdk/json/common_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

// Colors
const Color ScanbotRedColor = Color(0xFFc8193c);

// Alert Dialog
Future<void> showAlertDialog(BuildContext context, String textToShow,
    {String? title}) async {
  Widget text = SimpleDialogOption(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(textToShow),
    ),
  );

  // set up the SimpleDialog
  final dialog = AlertDialog(
    title: title != null ? Text(title) : null,
    content: text,
    contentPadding: const EdgeInsets.all(0),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('OK'),
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
  final result = await ScanbotSdk.getLicenseStatus();
  if (result.isLicenseValid) {
    return true;
  }
  await showAlertDialog(
      context, 'Scanbot SDK (trial) period or license has expired.',
      title: 'Info');
  return false;
}

bool isOperationSuccessful(Result result) {
  return result.operationResult == OperationResult.SUCCESS;
}
