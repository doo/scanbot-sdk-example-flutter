import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_image_picker/models/image_picker_response.dart';
import 'package:scanbot_image_picker/scanbot_image_picker_flutter.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;
import 'package:scanbot_sdk/scanbot_sdk_v2.dart' as scanbotV2;

import 'package:scanbot_sdk_example_flutter/ui/ready_to_use_ui/barcode_preview.dart';
import 'package:scanbot_sdk_example_flutter/ui/barcode_preview_multi_image.dart';
import 'package:scanbot_sdk_example_flutter/ui/classical_components/barcode_custom_ui.dart';
import 'package:scanbot_sdk_example_flutter/ui/classical_components/document_custom_ui.dart';
import 'package:scanbot_sdk_example_flutter/ui/classical_components/medical_certificate_custom_ui.dart';
import 'package:scanbot_sdk_example_flutter/ui/generic_document_preview.dart';
import 'package:scanbot_sdk_example_flutter/ui/mc_preview.dart';
import 'package:scanbot_sdk_example_flutter/ui/mrz_document_preview.dart';
import 'package:scanbot_sdk_example_flutter/ui/preview_document_widget.dart';
import 'package:scanbot_sdk_example_flutter/ui/progress_dialog.dart';

import 'pages_repository.dart';
import 'ui/menu_items.dart';
import 'ui/ready_to_use_ui_legacy/barcode_preview_v2.dart';
import 'utility/utils.dart';

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
      // Consider switching logging OFF in production builds for security and performance reasons.
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
  final PageRepository _pageRepository = PageRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ScanbotRedColor,
        title: const Text(
          'Scanbot SDK Example Flutter',
        ),
      ),
      body: ListView(
        children: <Widget>[
          const TitleItemWidget(title: 'Document Scanner'),
          MenuItemWidget(
            title: 'Scan Documents',
            onTap: () {
              _startDocumentScanning();
            },
          ),
          MenuItemWidget(
            title: 'Generic Document Scanner',
            onTap: () {
              _startGenericDocumentScanner();
            },
          ),
          MenuItemWidget(
            title: 'Import Image',
            onTap: () {
              _importImage();
            },
          ),
          MenuItemWidget(
            title: 'View Image Results',
            endIcon: Icons.keyboard_arrow_right,
            onTap: () {
              _gotoImagesView();
            },
          ),
          const TitleItemWidget(title: 'Barcode Scanners (RTU v2.0)'),
          MenuItemWidget(
            title: "Single Scan with confirmation dialog (RTU v2.0)",
            onTap: () {
              startSingleScanV2();
            },
          ),
          MenuItemWidget(
            title: "Multiple Scan (RTU v2.0)",
            onTap: () {
              startMultipleScanV2();
            },
          ),
          MenuItemWidget(
            title: "Find and Pick (RTU v2.0)",
            onTap: () {
              startFindAndPickScanV2();
            },
          ),
          MenuItemWidget(
            title: "AROverlay (RTU v2.0)",
            onTap: () {
              startAROverlayScanV2();
            },
          ),
          MenuItemWidget(
            title: "Info Mapping (RTU v2.0)",
            onTap: () {
              startInfoMappingScanV2();
            },
          ),
          const TitleItemWidget(title: 'Legacy Scanners'),
          MenuItemWidget(
            title: 'Scan Barcode (all formats: 1D + 2D)',
            onTap: () {
              _startBarcodeScanner();
            },
          ),
          MenuItemWidget(
            title: 'Scan QR code (QR format only)',
            onTap: () {
              _startQRScanner();
            },
          ),
          MenuItemWidget(
            title: 'Scan Multiple Barcodes (batch mode)',
            onTap: () {
              _startBatchBarcodeScanner();
            },
          ),
          const TitleItemWidget(title: 'From Image Detectors'),
          MenuItemWidget(
            title: 'Detect MRZ from Still Image',
            onTap: () {
              _recognizeMrzOnImage();
            },
          ),
          MenuItemWidget(
            title: 'Detect Barcodes from Still Image',
            onTap: () {
              _detectBarcodeOnImage();
            },
          ),
          MenuItemWidget(
            title: 'Detect Barcodes from Multiple Still Images',
            onTap: () {
              _detectBarcodesOnImages();
            },
          ),
          const TitleItemWidget(title: 'Custom UI'),
          MenuItemWidget(
            title: 'Scan Barcode (Custom UI)',
            onTap: () {
              _startBarcodeCustomUIScanner();
            },
          ),
          MenuItemWidget(
            title: 'Scan Documents (Custom UI)',
            onTap: () {
              _startDocumentsCustomUIScanner();
            },
          ),
          MenuItemWidget(
            title: 'Scan Medical Certificate (Custom UI)',
            onTap: () {
              _startMedicalCertificateCustomUIScanner();
            },
          ),
          const TitleItemWidget(title: 'Data Detectors'),
          MenuItemWidget(
            title: 'Scan MRZ (Machine Readable Zone)',
            onTap: () {
              _startMRZScanner();
            },
          ),
          MenuItemWidget(
            title: 'Scan EHIC (European Health Insurance Card)',
            onTap: () {
              _startEhicScanner();
            },
          ),
          MenuItemWidget(
            title: 'Scan License Plate',
            onTap: () {
              startLicensePlateScanner();
            },
          ),
          MenuItemWidget(
            title: 'Scan VIN',
            onTap: () {
              startVINScanner();
            },
          ),
          MenuItemWidget(
            title: 'Scan Check',
            onTap: () {
              startCheckScanner();
            },
          ),
          MenuItemWidget(
            title: 'Scan Text Data',
            onTap: () {
              startTextDataScanner();
            },
          ),
          MenuItemWidget(
            title: 'Scan Medical Certificate',
            onTap: () {
              startMedicalCertificateScanner();
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

  Future<void> _importImage() async {
    try {
      final response = await ScanbotImagePickerFlutter.pickImageAsync();
      var uriPath = response.uri ?? "";
      if (uriPath.isNotEmpty) {
        await _createPage(Uri.file(uriPath));
        await _gotoImagesView();
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> _recognizeMrzOnImage() async {
    try {
      final response = await ScanbotImagePickerFlutter.pickImageAsync();
      var uriPath = response.uri ?? "";
      if (uriPath.isNotEmpty) {
        var res = await ScanbotSdkUi.startRecognizeMrzOnImage(uriPath);
        if (res.operationResult == OperationResult.SUCCESS) {
          await showAlertDialog(context,
              "Document: ${res.documentType}\nrawMrz:\n${res.rawMrz}\ndocumentNumber: ${res.document?.documentNumber}",
              title: 'MRZ recognized');
        }
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> _createPage(Uri uri) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    final dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: 'Processing');
    dialog.show();
    try {
      var page = await ScanbotSdk.createPage(uri, false);
      page = await ScanbotSdk.detectDocument(page);
      await _pageRepository.addPage(page);
    } catch (e) {
      Logger.root.severe(e);
    } finally {
      await dialog.hide();
    }
  }

  Future<void> _startDocumentScanning() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    DocumentScanningResult? result;
    try {
      var config = DocumentScannerConfiguration(
        bottomBarBackgroundColor: ScanbotRedColor,
        ignoreBadAspectRatio: true,
        multiPageEnabled: true,
        //maxNumberOfPages: 3,
        //flashEnabled: true,
        //autoSnappingSensitivity: 0.7,
        cameraPreviewMode: CameraPreviewMode.FIT_IN,
        orientationLockMode: OrientationLockMode.PORTRAIT,
        //documentImageSizeLimit: Size(2000, 3000),
        cancelButtonTitle: 'Cancel',
        pageCounterButtonTitle: '%d Page(s)',
        textHintOK: "Perfect, don't move...",
        //textHintNothingDetected: "Nothing",
        // ...
      );
      result = await ScanbotSdkUi.startDocumentScanner(config);
    } catch (e) {
      Logger.root.severe(e);
    }
    if (result != null) {
      if (isOperationSuccessful(result)) {
        await _pageRepository.addPages(result.pages);
        await _gotoImagesView();
      }
    }
  }

  startSingleScanV2() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      // Create the default configuration object.
      var configuration = scanbotV2.BarcodeScannerConfiguration();

      // Initialize the single-scan use case.
      var singleUsecase = scanbotV2.SingleScanningMode();

      // Enable and configure the confirmation sheet.
      singleUsecase.confirmationSheetEnabled = true;
      singleUsecase.sheetColor = ScanbotColor("#FFFFFF");

      // Hide/unhide the barcode image.
      singleUsecase.barcodeImageVisible = true;

      // Configure the barcode title of the confirmation sheet.
      singleUsecase.barcodeTitle.visible = true;
      singleUsecase.barcodeTitle.color = ScanbotColor("#000000");

      // Configure the barcode subtitle of the confirmation sheet.
      singleUsecase.barcodeSubtitle.visible = true;
      singleUsecase.barcodeSubtitle.color = ScanbotColor("#000000");

      // Configure the cancel button of the confirmation sheet.
      singleUsecase.cancelButton.text = "Close";
      singleUsecase.cancelButton.foreground.color = ScanbotColor("#C8193C");
      singleUsecase.cancelButton.background.fillColor =
          ScanbotColor("#00000000");

      // Configure the submit button of the confirmation sheet.
      singleUsecase.submitButton.text = "Submit";
      singleUsecase.submitButton.foreground.color = ScanbotColor("#FFFFFF");
      singleUsecase.submitButton.background.fillColor = ScanbotColor("#C8193C");

      // Set the configured use case.
      configuration.useCase = singleUsecase;

      // Create and set an array of accepted barcode formats.
      // configuration.recognizerConfiguration.barcodeFormats = [
      //   scanbotV2.BarcodeFormat.AZTEC,
      //   scanbotV2.BarcodeFormat.PDF_417,
      //   scanbotV2.BarcodeFormat.QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_PDF_417,
      //   scanbotV2.BarcodeFormat.ROYAL_MAIL,
      // ];

      var result =
          await scanbotV2.ScanbotSdkUi.startBarcodeScanner(configuration);

      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  BarcodesResultPreviewWidgetV2(result.value!)),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  startMultipleScanV2() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      // Create the default configuration object.
      var configuration = scanbotV2.BarcodeScannerConfiguration();

      // Initialize the single-scan use case.
      var multiUsecase = scanbotV2.MultipleScanningMode();

      // Set the counting repeat delay.
      multiUsecase.countingRepeatDelay = 1000;

      // Set the counting mode.
      multiUsecase.mode = scanbotV2.MultipleBarcodesScanningMode.COUNTING;

      // Set the sheet mode of the barcodes preview.
      multiUsecase.sheet.mode = scanbotV2.SheetMode.COLLAPSED_SHEET;

      // Set the height of the collapsed sheet.
      multiUsecase.sheet.collapsedVisibleHeight =
          scanbotV2.CollapsedVisibleHeight.LARGE;

      // Enable manual count change.
      multiUsecase.sheetContent.manualCountChangeEnabled = true;

      // Configure the submit button.
      multiUsecase.sheetContent.submitButton.text = "Submit";
      multiUsecase.sheetContent.submitButton.foreground.color =
          ScanbotColor("#000000");

      // Set the configured use case.
      configuration.useCase = multiUsecase;

      // Create and set an array of accepted barcode formats.
      // configuration.recognizerConfiguration.barcodeFormats = [
      //   scanbotV2.BarcodeFormat.AZTEC,
      //   scanbotV2.BarcodeFormat.PDF_417,
      //   scanbotV2.BarcodeFormat.QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_PDF_417,
      //   scanbotV2.BarcodeFormat.ROYAL_MAIL,
      // ];

      var result =
          await scanbotV2.ScanbotSdkUi.startBarcodeScanner(configuration);

      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  BarcodesResultPreviewWidgetV2(result.value!)),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  startFindAndPickScanV2() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      // Create the default configuration object.
      var configuration = scanbotV2.BarcodeScannerConfiguration();

      // Initialize the single-scan use case.
      var usecase = scanbotV2.FindAndPickScanningMode();

      // Set the configured use case.
      configuration.useCase = usecase;

      // Configure AR Overlay.
      usecase.arOverlay.visible = true;

      // Enable/Disable the automatic selection.
      usecase.arOverlay.automaticSelectionEnabled = false;

      // Enable/Disable the swipe to delete.
      usecase.sheetContent.swipeToDelete.enabled = true;

      // Enable/Disable allow partial scan.
      usecase.allowPartialScan = true;

      // Set the expected barcodes.
      usecase.expectedBarcodes = [
        scanbotV2.ExpectedBarcode(
            barcodeValue: "123456", title: "", image: "Image_URL", count: 4),
        scanbotV2.ExpectedBarcode(
            barcodeValue: "SCANBOT", title: "", image: "Image_URL", count: 3)
      ];

      // Set the configured usecase.
      configuration.useCase = usecase;

      var result =
          await scanbotV2.ScanbotSdkUi.startBarcodeScanner(configuration);

      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  BarcodesResultPreviewWidgetV2(result.value!)),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  startAROverlayScanV2() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      // Create the default configuration object.
      var configuration = scanbotV2.BarcodeScannerConfiguration();

      // Configure the usecase.
      var usecase = scanbotV2.MultipleScanningMode();
      usecase.mode = scanbotV2.MultipleBarcodesScanningMode.UNIQUE;
      usecase.sheet.mode = scanbotV2.SheetMode.COLLAPSED_SHEET;
      usecase.sheet.collapsedVisibleHeight =
          scanbotV2.CollapsedVisibleHeight.SMALL;

      // Configure AR Overlay.
      usecase.arOverlay.visible = true;
      usecase.arOverlay.automaticSelectionEnabled = false;

      // Set the configured usecase.
      configuration.useCase = usecase;

      // Create and set an array of accepted barcode formats.
      // configuration.recognizerConfiguration.barcodeFormats = [
      //   scanbotV2.BarcodeFormat.AZTEC,
      //   scanbotV2.BarcodeFormat.PDF_417,
      //   scanbotV2.BarcodeFormat.QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_PDF_417,
      //   scanbotV2.BarcodeFormat.ROYAL_MAIL,
      // ];

      // Set the configured usecase.
      configuration.useCase = usecase;

      var result =
          await scanbotV2.ScanbotSdkUi.startBarcodeScanner(configuration);

      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  BarcodesResultPreviewWidgetV2(result.value!)),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  startInfoMappingScanV2() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      var configuration = scanbotV2.BarcodeScannerConfiguration();
      var singleScanningMode = scanbotV2.SingleScanningMode();

      // Enable the confirmation sheet.
      singleScanningMode.confirmationSheetEnabled = true;

      // Set the item mapper.
      singleScanningMode.barcodeInfoMapping.barcodeItemMapper =
          (item, onResult, onError) async {
        //return result
        onResult(scanbotV2.BarcodeMappedData(
            title: "Title", subtitle: "Subtitle", barcodeImage: "Image_URL"));

        // if need to show error
        // onError();
      };

      // Retrieve the instance of the error state from the use case object.
      var errorState = singleScanningMode.barcodeInfoMapping.errorState;

      // Configure the title.
      errorState.title.text = "Error_Title";
      errorState.title.color = ScanbotColor("#000000");

      // Configure the subtitle.
      errorState.subtitle.text = "Error_Subtitle";
      errorState.subtitle.color = ScanbotColor("#000000");

      // Configure the cancel button.
      errorState.cancelButton.text = "Cancel";
      errorState.cancelButton.foreground.color = ScanbotColor("#C8193C");

      // Configure the retry button.
      errorState.retryButton.text = "Retry";
      errorState.retryButton.foreground.iconVisible = true;
      errorState.retryButton.foreground.color = ScanbotColor("#FFFFFF");
      errorState.retryButton.background.fillColor = ScanbotColor("#C8193C");

      // Set the configured error state.
      singleScanningMode.barcodeInfoMapping.errorState = errorState;

      // Set the configured use case.
      configuration.useCase = singleScanningMode;

      // Create and set an array of accepted barcode formats.
      // configuration.recognizerConfiguration.barcodeFormats = [
      //   scanbotV2.BarcodeFormat.AZTEC,
      //   scanbotV2.BarcodeFormat.PDF_417,
      //   scanbotV2.BarcodeFormat.QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_QR_CODE,
      //   scanbotV2.BarcodeFormat.MICRO_PDF_417,
      //   scanbotV2.BarcodeFormat.ROYAL_MAIL,
      // ];

      var result =
          await scanbotV2.ScanbotSdkUi.startBarcodeScanner(configuration);
      if (result.operationResult == OperationResult.SUCCESS) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>
                  BarcodesResultPreviewWidgetV2(result.value!)),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _startBarcodeScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      var config = BarcodeScannerConfiguration(
        topBarBackgroundColor: ScanbotRedColor,
        barcodeFormats: PredefinedBarcodes.allBarcodeTypes(),
        cameraOverlayColor: Colors.amber,
        overlayConfiguration: SelectionOverlayConfiguration(
            overlayEnabled: true,
            polygonColor: Colors.red,
            automaticSelectionEnabled: false),
        finderAspectRatio: sdk.AspectRatio(width: 4, height: 2),
        finderTextHint:
            'Please align any supported barcode in the frame to scan it.',
        viewFinderEnabled: true,
        /*  additionalParameters: BarcodeAdditionalParameters(
          enableGS1Decoding: false,
          minimumTextLength: 10,
          maximumTextLength: 11,
          minimum1DBarcodesQuietZone: 10,
        )*/
        //cameraZoomFactor: 0.5,
        // ...
      );
      var result = await ScanbotSdkUi.startBarcodeScanner(config);
      await _showBarcodeScanningResult(result);
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> _startBarcodeCustomUIScanner() async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const BarcodeScannerWidget()),
    );

    //handle result if it was returned
    if (result is BarcodeScanningResult) {
      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(result)),
      );
    }
  }

  Future<void> _startDocumentsCustomUIScanner() async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const DocumentScannerWidget()),
    );

    //handle result if it was returned
    if (result is List<sdk.Page>) {
      _pageRepository.addPages(result);
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => DocumentPreview()),
      );
    }
  }

  Future<void> _startMedicalCertificateCustomUIScanner() async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const MedicalCertificateScannerWidget()),
    );

    //handle result if it was returned
    if (result is MedicalCertificateResult) {
      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => MedicalCertificatePreviewWidget(result)),
      );
    }
  }

  Future<void> _startGenericDocumentScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    GenericDocumentResults? result;
    try {
      var config = GenericDocumentRecognizerConfiguration(
          acceptedDocumentTypes: [
            GenericDocumentType.DE_RESIDENCE_PERMIT_FRONT,
            GenericDocumentType.DE_RESIDENCE_PERMIT_BACK,
            GenericDocumentType.DE_DRIVER_LICENSE_FRONT,
            GenericDocumentType.DE_DRIVER_LICENSE_BACK,
            GenericDocumentType.DE_ID_CARD_FRONT,
            GenericDocumentType.DE_ID_CARD_BACK,
            GenericDocumentType.DE_PASSPORT,
          ],
          topBarBackgroundColor: Colors.red,
          fieldConfidenceLowColor: Colors.blue,
          fieldConfidenceHighColor: Colors.purpleAccent,
          fieldsDisplayConfiguration: [
            // All types of documents have its own class for field signatures, e.g. DeIdCardFront -> DeIdCardFrontFieldsSignatures. From this classes you can take field signatures for each field you want to configure.
            FieldsDisplayConfiguration(DeDriverLicenseFrontFieldNames.Surname,
                "My Surname", FieldDisplayState.ALWAYS_VISIBLE),
            FieldsDisplayConfiguration(
                DeDriverLicenseFrontFieldNames.GivenNames,
                "My GivenNames",
                FieldDisplayState.ALWAYS_VISIBLE),
            FieldsDisplayConfiguration(DeDriverLicenseFrontFieldNames.BirthDate,
                "My Birth Date", FieldDisplayState.ALWAYS_VISIBLE),
            FieldsDisplayConfiguration(
                DeDriverLicenseFrontFieldNames.ExpiryDate,
                "Document Expiry Date",
                FieldDisplayState.ALWAYS_VISIBLE),
            FieldsDisplayConfiguration(DeResidencePermitBackFieldNames.Address,
                "My address", FieldDisplayState.ALWAYS_VISIBLE),
            // FieldsDisplayConfiguration(
            //     DeResidencePermitBackFieldNames.IssueDate,
            //     "When issued",
            //     FieldDisplayState.ALWAYS_VISIBLE),
            FieldsDisplayConfiguration(
                DeResidencePermitBackFieldNames.IssuingAuthority,
                "Who issued",
                FieldDisplayState.ALWAYS_VISIBLE),
            FieldsDisplayConfiguration(MRZFieldNames.DocumentNumber,
                "My Doc Num", FieldDisplayState.ALWAYS_VISIBLE),
            FieldsDisplayConfiguration(MRZFieldNames.Surname, "My Surname",
                FieldDisplayState.ALWAYS_VISIBLE),
          ],
          documentsDisplayConfiguration: [
            DocumentsDisplayConfiguration(
                DeIdCardBack.DOCUMENT_NORMALIZED_TYPE, "Id Card Back Side"),
            DocumentsDisplayConfiguration(
                DePassport.DOCUMENT_NORMALIZED_TYPE, "Passport"),
            DocumentsDisplayConfiguration(
                MRZ.DOCUMENT_NORMALIZED_TYPE, "MRZ on document back"),
            DocumentsDisplayConfiguration(
                DeDriverLicenseFront.DOCUMENT_NORMALIZED_TYPE,
                "Licence plate Front"),
            DocumentsDisplayConfiguration(
                DeDriverLicenseBack.DOCUMENT_NORMALIZED_TYPE,
                "Licence plate Back"),
          ]);
      result = await ScanbotSdkUi.startGenericDocumentRecognizer(config);
      // result.documents.first.document.wrapDocument();
      _showGenericDocumentRecognizerResult(result);
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> _startBatchBarcodeScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      var config = BatchBarcodeScannerConfiguration(
        barcodeFormatter: (item) async {
          final random = Random();
          final randomNumber = random.nextInt(4) + 2;
          await Future.delayed(Duration(seconds: randomNumber));
          return BarcodeFormattedData(
              title: item.barcodeFormat.toString(),
              subtitle: (item.text ?? '') + 'custom string');
        },
        cancelButtonTitle: 'Cancel',
        enableCameraButtonTitle: 'camera enable',
        enableCameraExplanationText: 'explanation text',
        finderTextHint:
            'Please align any supported barcode in the frame to scan it.',
        // clearButtonTitle: "CCCClear",
        // submitButtonTitle: "Submitt",
        barcodesCountText: '%d codes',
        fetchingStateText: 'might be not needed',
        noBarcodesTitle: 'nothing to see here',
        finderAspectRatio: sdk.AspectRatio(width: 3, height: 2),
        finderLineWidth: 7,
        successBeepEnabled: true,
        // flashEnabled: true,
        orientationLockMode: OrientationLockMode.PORTRAIT,
        barcodeFormats: PredefinedBarcodes.allBarcodeTypes(),
        cancelButtonHidden: false,
        //cameraZoomFactor: 0.5
        /*additionalParameters: BarcodeAdditionalParameters(
          enableGS1Decoding: false,
          minimumTextLength: 10,
          maximumTextLength: 11,
          minimum1DBarcodesQuietZone: 10,
        )*/
      );

      final result = await ScanbotSdkUi.startBatchBarcodeScanner(config);
      if (result.operationResult == OperationResult.SUCCESS) {
        await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => BarcodesResultPreviewWidget(result)),
        );
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> _detectBarcodeOnImage() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      var response = await ScanbotImagePickerFlutter.pickImageAsync();
      var uriPath = response.uri ?? "";
      if (uriPath.isEmpty) {
        ValidateUriError(response);
        return;
      }

      ///before processing image sdk need storage read permission
      final permissions =
          await [Permission.storage, Permission.photos].request();
      if (permissions[Permission.storage] ==
              PermissionStatus.granted || //android
          permissions[Permission.photos] == PermissionStatus.granted) {
        //ios
        var result = await ScanbotSdk.detectBarcodesOnImage(Uri.file(uriPath),
            barcodeFormats: PredefinedBarcodes.allBarcodeTypes());
        if (result.operationResult == OperationResult.SUCCESS) {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => BarcodesResultPreviewWidget(result)),
          );
        }
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  /// Detect barcodes from multiple still images
  Future<void> _detectBarcodesOnImages() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      List<Uri> uris = List.empty(growable: true);
      var response = await ScanbotImagePickerFlutter.pickImagesAsync();
      if (response.uris?.isNotEmpty == true) {
        uris = response.PathsToUris(response.uris);
      }

      if (response.message?.isNotEmpty == true) {
        ValidateUriError(response);
      }

      ///before processing image sdk need storage read permission
      final permissions =
          await [Permission.storage, Permission.photos].request();
      if (permissions[Permission.storage] ==
              PermissionStatus.granted || //android
          permissions[Permission.photos] == PermissionStatus.granted) {
        //ios
        var result = await ScanbotSdk.detectBarcodesOnImages(uris,
            barcodeFormats: PredefinedBarcodes.allBarcodeTypes());
        if (result.operationResult == OperationResult.SUCCESS) {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MultiImageBarcodesResultPreviewWidget(
                  result.barcodeResults)));
        }
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> startLicensePlateScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    LicensePlateScanResult requestResult;
    try {
      var config = LicensePlateScannerConfiguration(
          topBarBackgroundColor: Colors.pink,
          topBarButtonsActiveColor: Colors.white70,
          confirmationDialogAccentColor: Colors.green);
      requestResult = await ScanbotSdkUi.startLicensePlateScanner(config);
      if (requestResult.operationResult == OperationResult.SUCCESS) {
        showResultTextDialog(requestResult.rawText);
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> startVINScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    VinScanResult requestResult;
    try {
      var config = VinScannerConfiguration();
      requestResult = await ScanbotSdkUi.startVinScanner(config);
      if (requestResult.operationResult == OperationResult.SUCCESS) {
        showResultTextDialog(requestResult.rawText);
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> startCheckScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    CheckScanResult requestResult;
    try {
      var config = CheckScannerConfiguration();
      requestResult = await ScanbotSdkUi.startCheckScanner(config);
      if (requestResult.operationResult == OperationResult.SUCCESS) {
        showResultTextDialog(requestResult.check?.type.name);
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> startTextDataScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    TextDataScanResult requestResult;
    try {
      var config = TextDataScannerConfiguration();
      requestResult = await ScanbotSdkUi.startTextDataScanner(config);
      if (requestResult.operationResult == OperationResult.SUCCESS) {
        showResultTextDialog(jsonEncode(requestResult));
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> startMedicalCertificateScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    MedicalCertificateResult requestResult;
    try {
      var config = MedicalCertificateScannerConfiguration();
      requestResult = await ScanbotSdkUi.startMedicalCertificateScanner(config);
      if (requestResult.operationResult == OperationResult.SUCCESS) {
        showResultTextDialog(requestResult.patientInfoBox.toString());
      }
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  void showResultTextDialog(result) {
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

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _startQRScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      final config = BarcodeScannerConfiguration(
        barcodeFormats: [BarcodeFormat.QR_CODE],
        finderTextHint: 'Please align a QR code in the frame to scan it.',
        /*  additionalParameters: BarcodeAdditionalParameters(
          enableGS1Decoding: false,
          minimumTextLength: 10,
          maximumTextLength: 11,
          minimum1DBarcodesQuietZone: 10,
        )*/
        // ...
      );
      final result = await ScanbotSdkUi.startBarcodeScanner(config);
      await _showBarcodeScanningResult(result);
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> _showBarcodeScanningResult(
      final BarcodeScanningResult result) async {
    if (result.operationResult == OperationResult.SUCCESS) {
      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => BarcodesResultPreviewWidget(result)),
      );
    }
  }

  Future<void> _showGenericDocumentRecognizerResult(
      final GenericDocumentResults result) async {
    if (isOperationSuccessful(result)) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GenericDocumentResultPreview(result),
        ),
      );
    }
  }

  Future<void> _startEhicScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    HealthInsuranceCardRecognitionResult? result;
    try {
      final config = HealthInsuranceScannerConfiguration(
        topBarBackgroundColor: ScanbotRedColor,
        topBarButtonsActiveColor: Colors.white70,
        // ...
      );
      result = await ScanbotSdkUi.startEhicScanner(config);
    } catch (e) {
      Logger.root.severe(e);
    }
    if (result != null) {
      if (isOperationSuccessful(result)) {
        var concatenate = StringBuffer();
        result.fields
            .map((field) =>
                "${field.type.toString().replaceAll("HealthInsuranceCardFieldType.", "")}:${field.value}\n")
            .forEach((s) {
          concatenate.write(s);
        });
        await showAlertDialog(context, concatenate.toString());
      }
    }
  }

  Future<void> _startMRZScanner() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    MrzScanningResult? result;
    try {
      final config = MrzScannerConfiguration(
        topBarBackgroundColor: ScanbotRedColor,
      );
      if (Platform.isIOS) {
        config.finderAspectRatio = sdk.AspectRatio(width: 7, height: 1);
      }
      result = await ScanbotSdkUi.startMrzScanner(config);
    } catch (e) {
      Logger.root.severe(e);
    }

    if (result != null && isOperationSuccessful(result)) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => MrzDocumentResultPreview(result)),
      );
    }
  }

  Future<dynamic> _gotoImagesView() async {
    return await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => DocumentPreview()),
    );
  }

  /// Check for error message and display accordingly.
  void ValidateUriError(ImagePickerResponse response) {
    var message = response.message ?? "";
    if (message.isEmpty) {
      message = "RESULT IS EMPTY";
    }
    showAlertDialog(context, message);
  }
}
