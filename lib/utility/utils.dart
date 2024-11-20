import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

const Color ScanbotRedColor = Color(0xFFc8193c);

Future<void> showAlertDialog(BuildContext context, String textToShow,
    {String? title}) async {
  Widget text = SimpleDialogOption(
    child: Text(textToShow),
  );

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

void showResultTextDialog(BuildContext context, result) {
  Widget okButton = TextButton(
    onPressed: () => Navigator.pop(context),
    child: const Text('OK'),
  );
  // set up the AlertDialog
  var alert = AlertDialog(
    title: const Text('Result'),
    content: Text(result),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
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
