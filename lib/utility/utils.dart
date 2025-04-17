import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:url_launcher/url_launcher.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';

bool shouldInitWithEncryption = false;

final enableImagesInScannedBarcodesResults = false;
final selectedFormatsNotifier = ValueNotifier<Set<BarcodeFormat>>(
    BarcodeFormats.all.toSet()
);

const Color ScanbotRedColor = Color(0xFFc8193c);

const AppBarTitleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w400,
  color: Colors.white,
  fontFamily: 'Roboto',
);

AppBar ScanbotAppBar(String title, {bool showBackButton = false, BuildContext? context, List<Widget>? actions}) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    backgroundColor: ScanbotRedColor,
    leading: showBackButton && context != null
        ? GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: const Icon(Icons.arrow_back, color: Colors.white),
    )
        : null,
    title: Text(
      title,
      style: AppBarTitleTextStyle
    ),
    actions: actions,
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
  return result.operationResult == OperationStatus.OK;
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
          'Copyright 2025 Scanbot SDK GmbH. All rights reserved.',
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

Future<XFile?> selectImageFromLibrary() async {
  return await ImagePicker().pickImage(source: picker.ImageSource.gallery);
}

