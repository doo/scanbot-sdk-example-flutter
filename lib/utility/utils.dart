import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';

const Color ScanbotRedColor = Color(0xFFc8193c);

AppBar ScanbotAppBar(String title) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    backgroundColor: ScanbotRedColor,
    title: Text(
      title,
      style: const TextStyle(
        inherit: true,
        color: Colors.white,
        fontSize: 20
      ),
    ),
  );
}

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

Widget buildBottomNavigationBar(BuildContext context) {
  return Container(
    color: Colors.grey[200],
    padding: const EdgeInsets.all(10.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: _launchScanbotSDKURL,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Learn More About Scanbot SDK',
            style: TextStyle(
              color: ScanbotRedColor,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Copyright 2024 Scanbot SDK GmbH. All rights reserved.',
          style: TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}

Future<void> _launchScanbotSDKURL() async {
  var url = Uri.parse("https://scanbot.io/");
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw 'Could not launch $url';
  }
}

bool isOperationSuccessful(Result result) {
  return result.operationResult == OperationResult.SUCCESS;
}

Future<XFile?> selectImageFromLibrary() async {
  return await ImagePicker().pickImage(source: ImageSource.gallery);
}
