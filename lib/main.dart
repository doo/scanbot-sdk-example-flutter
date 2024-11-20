import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import 'storage/pages_repository.dart';
import 'ui/menu_item_widget.dart';
import 'utility/utils.dart';
import 'barcode/barcode_sdk_menu.dart';
import 'data_capture/data_capture_sdk_menu.dart';
import 'document/document_sdk_menu.dart';
import 'classic_components/custom_ui_menu.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';

/// true - if you need to enable encryption for example app
bool shouldInitWithEncryption = false;

void main() => runApp(MyApp());

// TODO add the Scanbot SDK license key here.
// Please note: The Scanbot SDK will run without a license key for one minute per session!
// After the trial period is over all Scanbot SDK functions as well as the UI components will stop working
// or may be terminated. You can get an unrestricted "no-strings-attached" 30 day trial license key for free.
// Please submit the trial license form (https://scanbot.io/en/sdk/demo/trial) on our website by using
// the app identifier "io.scanbot.example.flutter" of this example app or of your app.
const SCANBOT_SDK_LICENSE_KEY = "";

Future<void> _initScanbotSdk() async {
  // Consider adjusting this optional storageBaseDirectory - see the comments below.
  final customStorageBaseDirectory = await getDemoStorageBaseDirectory();

  final encryptionParams = _getEncryptionParams();

  var config = ScanbotSdkConfig(
      loggingEnabled: true,
      // Consider switching logging OFF in production. builds for security and performance reasons.
      licenseKey: SCANBOT_SDK_LICENSE_KEY,
      imageFormat: ImageFormat.JPG,
      imageQuality: 80,
      storageBaseDirectory: customStorageBaseDirectory,
      documentDetectorMode: DocumentDetectorMode.ML_BASED,
      encryptionParameters: encryptionParams);
  try {
    await ScanbotSdk.initScanbotSdk(config);
    await PageRepository().loadPages();
  } catch (e) {
    Logger.root.severe(e);
  }
}

EncryptionParameters? _getEncryptionParams() {
  EncryptionParameters? encryptionParams;
  if (shouldInitWithEncryption) {
    encryptionParams = EncryptionParameters(
      password: 'SomeSecretPa\$\$w0rdForFileEncryption',
      mode: FileEncryptionMode.AES256,
    );
  }
  return encryptionParams;
}

Future<String> getDemoStorageBaseDirectory() async {
  // !! Please note !!
  // It is strongly recommended to use the default (secure) storage location of the Scanbot SDK.
  // However, for demo purposes we overwrite the "storageBaseDirectory" of the Scanbot SDK by a custom storage directory.
  //
  // On Android we use the "ExternalStorageDirectory" which is a public(!) folder.
  // All image files and export files (PDF, TIFF, etc) created by the Scanbot SDK in this demo app will be stored
  // in this public storage directory and will be accessible for every(!) app having external storage permissions!
  // Again, this is only for demo purposes, which allows us to easily fetch and check the generated files
  // via Android "adb" CLI tools, Android File Transfer app, Android Studio, etc.
  //
  // On iOS we use the "ApplicationDocumentsDirectory" which is accessible via iTunes file sharing.
  //
  // For more details about the storage system of the Scanbot SDK Flutter Plugin please see our docs:
  // - https://scanbotsdk.github.io/documentation/flutter/
  //
  // For more details about the file system on Android and iOS we also recommend to check out:
  // - https://developer.android.com/guide/topics/data/data-storage
  // - https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html

  Directory storageDirectory;
  if (Platform.isAndroid) {
    storageDirectory = (await getExternalStorageDirectory())!;
  } else if (Platform.isIOS) {
    storageDirectory = await getApplicationDocumentsDirectory();
  } else {
    throw ('Unsupported platform');
  }

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
  void initState() {
    super.initState();
  }

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
      appBar: AppBar(
        backgroundColor: ScanbotRedColor,
        title: const Text('Scanbot SDK Flutter Example'),
      ),
      body: ListView(
        children: [
          const TitleItemWidget(title: 'Document SDK API'),
          MenuItemWidget(
            title: 'Barcode SDK Menu',
            startIcon: Icons.qr_code_scanner,
            endIcon: Icons.arrow_forward,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BarcodeSdkMenu()),
              );
            },
          ),
          MenuItemWidget(
            title: 'Document SDK Menu',
            startIcon: Icons.photo_camera,
            endIcon: Icons.arrow_forward,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DocumentSdkMenu()),
              );
            },
          ),
          MenuItemWidget(
            title: 'Data Capture SDK Menu',
            startIcon: Icons.data_array,
            endIcon: Icons.arrow_forward,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DataCaptureSdkMenu()),
              );
            },
          ),
          MenuItemWidget(
            title: 'Custom UI Menu',
            startIcon: Icons.edit,
            endIcon: Icons.arrow_forward,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CustomUiMenu()),
              );
            },
          ),
          const TitleItemWidget(title: 'Test other SDK API methods'),
          MenuItemWidget(
            title: 'getLicenseStatus()',
            startIcon: Icons.phonelink_lock,
            onTap: () {
              _getLicenseStatus();
            },
          ),
          MenuItemWidget(
            title: 'getOcrConfigs()',
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
    );
  }

  Future<void> _getOcrConfigs() async {
    try {
      final result = await ScanbotSdk.getOcrConfigs();
      await showAlertDialog(context, jsonEncode(result), title: 'OCR Configs');
    } catch (e) {
      Logger.root.severe(e);
      await showAlertDialog(context, 'Error getting OCR configs');
    }
  }

  Future<void> _getLicenseStatus() async {
    try {
      final result = await ScanbotSdk.getLicenseStatus();
      await showAlertDialog(context,
          "Status: ${result.status} expirationDate: ${result.expirationDate}",
          title: 'License Status');
    } catch (e) {
      Logger.root.severe(e);
      await showAlertDialog(context, 'Error getting license status');
    }
  }
}
