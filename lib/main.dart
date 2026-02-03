import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanbot_sdk_example_flutter/classic_components/document_custom_ui.dart';

import 'ui/menu_item_widget.dart';
import 'utility/utils.dart';
import 'data_capture/data_capture_sdk_menu.dart';
import 'document/document_sdk_menu.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';

void main() => runApp(MyApp());

// TODO add the Scanbot SDK license key here.
// Please note: The Scanbot SDK will run without a license key for one minute per session!
// After the trial period is over all Scanbot SDK functions as well as the UI components will stop working
// or may be terminated. You can get an unrestricted "no-strings-attached" 30 day trial license key for free.
// Please submit the trial license form (https://scanbot.io/en/sdk/demo/trial) on our website by using
// the app identifier "io.scanbot.example.flutter" of this example app or of your app.
const SCANBOT_SDK_LICENSE_KEY = "";

Future<void> _initScanbotSdk() async {
  var config = SdkConfiguration(
      loggingEnabled: true,
      // Consider switching logging OFF in production. builds for security and performance reasons.
      licenseKey: SCANBOT_SDK_LICENSE_KEY,
      // Uncomment to use custom storage directory
      // storageBaseDirectory: await getDemoStorageBaseDirectory(),
      fileEncryptionPassword: shouldInitWithEncryption
          ? 'SomeSecretPa\$\$w0rdForFileEncryption'
          : null,
      fileEncryptionMode:
          shouldInitWithEncryption ? FileEncryptionMode.AES256 : null);

  await ScanbotSdk.initialize(config);
}

Future<String> getDemoStorageBaseDirectory() async {
  // !! Please note !!
  // It is strongly recommended to use the default (secure) storage location of the Scanbot SDK.
  // However, for demo purposes we overwrite the "storageBaseDirectory" of the Scanbot SDK by a custom storage directory.

  var storageDirectory = await getApplicationSupportDirectory();
  return '${storageDirectory.path}/my-custom-storage';
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    _initScanbotSdk();
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPageWidget(),
      navigatorObservers: [ScanbotCamera.scanbotSdkRouteObserver],
    );
  }
}

class MainPageWidget extends StatefulWidget {
  @override
  _MainPageWidgetState createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ScanbotAppBar('Scanbot SDK Flutter Example'),
        body: ListView(
          children: [
            const TitleItemWidget(title: 'Document SDK API'),
            MenuItemWidget(
              title: 'Document SDK Menu',
              startIcon: Icons.photo_camera,
              endIcon: Icons.arrow_forward,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const DocumentSdkMenu()),
                );
              },
            ),
            MenuItemWidget(
              title: 'Data Capture SDK Menu',
              startIcon: Icons.data_array,
              endIcon: Icons.arrow_forward,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const DataCaptureSdkMenu()),
                );
              },
            ),
            MenuItemWidget(
              title: 'Custom UI',
              startIcon: Icons.edit,
              endIcon: Icons.arrow_forward,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const DocumentScannerWidget()),
                );
              },
            ),
            const TitleItemWidget(title: 'Other SDK API'),
            MenuItemWidget(
              title: 'License Info',
              startIcon: Icons.phonelink_lock,
              onTap: () {
                _getLicenseStatus();
              },
            ),
            MenuItemWidget(
              title: 'Ocr Configs',
              startIcon: Icons.settings,
              onTap: () {
                _getOcrConfigs();
              },
            ),
            MenuItemWidget(
              title: '3rd-party Libs & Licenses',
              startIcon: Icons.developer_mode,
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: 'Scanbot SDK Flutter Example',
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: buildBottomNavigationBar(context));
  }

  Future<void> _getOcrConfigs() async {
    final result = await ScanbotSdk.getOcrConfigs();
    if (result is Ok<OcrConfigsResult>) {
      await showAlertDialog(context, jsonEncode(result.value),
          title: 'OCR Configs');
    }
  }

  Future<void> _getLicenseStatus() async {
    final result = await ScanbotSdk.getLicenseInfo();
    if (result is Ok<LicenseInfo>) {
      var licenseInfo =
          "Status: ${result.value.status.name}\nExpiration Date: ${result.value.expirationDateString}";

      await showAlertDialog(context, licenseInfo, title: 'License Status');
    }
  }
}
