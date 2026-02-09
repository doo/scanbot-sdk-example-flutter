import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../utility/utils.dart';
import 'cropping_custom_ui.dart';

/// This screen demonstrates how to integrate the classical barcode scanner component.
class DocumentScannerWidget extends StatefulWidget {
  const DocumentScannerWidget({Key? key}) : super(key: key);

  @override
  _DocumentScannerWidgetState createState() => _DocumentScannerWidgetState();
}

class _DocumentScannerWidgetState extends State<DocumentScannerWidget> {
  /// Stream to monitor the document detection status.
  final detectionStatusStream = StreamController<DocumentDetectionStatus>();

  // Various states used within the widget.
  bool permissionGranted = false;
  bool flashEnabled = false;
  bool autoSnappingEnabled = true;
  bool flashAvailable = false;
  bool showProgressBar = false;
  SBException? licenseError;

  DocumentScannerCameraController controller =
      DocumentScannerCameraController();

  /// Checks camera permission and updates the state accordingly.
  void checkPermission() async {
    // Note: Update iOS Podfile according to the `permission_handler` official installation guide! https://pub.dev/packages/permission_handler
    final permissionResult = await [Permission.camera].request();
    if (mounted) {
      setState(() {
        permissionGranted =
            permissionResult[Permission.camera]?.isGranted ?? false;
      });
    }
  }

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            _buildCameraView(),
            _buildDetectionStatusStream(),
            if (showProgressBar) _buildProgressIndicator(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: ScanbotRedColor,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      title: const Text(
        'Scan Documents',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
      ),
      actions: _buildAppBarActions(),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      if (permissionGranted && licenseError == null)
        IconButton(
          onPressed: () {
            if (mounted) {
              setState(() {
                autoSnappingEnabled = !autoSnappingEnabled;
              });
            }
          },
          icon: Icon(
            autoSnappingEnabled
                ? Icons.auto_mode_outlined
                : Icons.disabled_by_default,
          ),
        ),
      if (flashAvailable)
        IconButton(
          onPressed: () {
            if (mounted) {
              setState(() {
                flashEnabled = !flashEnabled;
              });
            }
          },
          icon: Icon(
            flashEnabled ? Icons.flash_on : Icons.flash_off,
          ),
        ),
    ];
  }

  /// Builds the view for the camera, handling different states.
  Widget _buildCameraView() {
    if (licenseError != null) {
      return _buildErrorMessage(licenseError!.message);
    }

    if (!permissionGranted) {
      return _buildErrorMessage('Permissions not granted');
    }

    return Stack(
      children: [
        DocumentScannerCamera(
          controller: controller,
          onSnappedDocumentResult: (
            ImageRef originalImage,
            ImageRef? documentImage,
            DocumentDetectionResult? detectionResult,
          ) async {
            await _startCustomCroppingScreen(originalImage);
          },
          onError: (error) {
            if (error is InvalidLicenseException) {
              setState(() {
                licenseError = error;
              });
            } else {
              Logger.root.severe(error.toString());
            }
          },
          onFrameDetectionResult: (result) {
            detectionStatusStream.add(result.status);
          },
          configuration: _buildDocumentCameraConfiguration(),
          onCameraPreviewStarted: (isFlashAvailable) {
            if (mounted) {
              setState(() {
                flashAvailable = isFlashAvailable;
              });
            }
          },
          onHeavyOperationProcessing: (show) {
            if (showProgressBar == show) return;

            setState(() {
              showProgressBar = show;
            });
          },
        ),
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ShutterButtonView(
                onPressed: () {
                  controller.snapDocument();
                },
                autosnappingMode: autoSnappingEnabled,
                primaryColor: Colors.pink,
                accentColor: Colors.white,
                animatedLineStrokeWidth: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _startCustomCroppingScreen(ImageRef documentImage) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              CroppingScreenWidget(documentImage: documentImage)),
    );
  }

  /// Builds the DocumentCameraConfiguration.
  DocumentCameraConfiguration _buildDocumentCameraConfiguration() {
    var documentClassicScannerConfiguration =
        DocumentClassicScannerConfiguration(
      autoSnapEnabled: autoSnappingEnabled,
      detectDocumentAfterSnap: false,
      acceptedSizeScore: 75,
      autoSnapSensitivity: 0.5,
    );

    return DocumentCameraConfiguration(
      flashEnabled: flashEnabled,
      scannerConfiguration: documentClassicScannerConfiguration,
      contourConfiguration: ContourConfiguration(
        showPolygonInManualMode: false,
        strokeOkColor: Colors.red,
        fillOkColor: Colors.red.withAlpha(150),
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withAlpha(150),
        cornerRadius: 35,
        strokeWidth: 10,
        autoSnapProgressStrokeColor: Colors.greenAccent,
        autoSnapProgressEnabled: true,
        autoSnapProgressStrokeWidth: 5,
      ),
    );
  }

  /// Builds the StreamBuilder for the detection status.
  Widget _buildDetectionStatusStream() {
    return StreamBuilder<DocumentDetectionStatus>(
      stream: detectionStatusStream.stream,
      builder: (context, snapshot) {
        if (snapshot.data == null ||
            !permissionGranted ||
            licenseError != null) {
          return Container();
        }
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Wrap(
              children: [
                DetectionStatusWidget(
                  status: snapshot.data ??
                      DocumentDetectionStatus.ERROR_NOTHING_DETECTED,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds a progress indicator to show when a heavy operation is in progress.
  Widget _buildProgressIndicator() {
    return const Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(
          strokeWidth: 10,
        ),
      ),
    );
  }

  /// Helper method to build an error message when permissions are not granted or license is inactive.
  Widget _buildErrorMessage(String message) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

/// A widget to display the document detection status.
class DetectionStatusWidget extends StatelessWidget {
  final DocumentDetectionStatus status;

  const DetectionStatusWidget({Key? key, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(150),
        borderRadius: const BorderRadiusDirectional.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Colors.green.withAlpha(150),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          status.name,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

/// A widget to preview the scanned page.
class PagePreview extends StatelessWidget {
  final Uint8List bytes;

  const PagePreview({Key? key, required this.bytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(child: Image.memory(bytes)),
      ),
    );
  }
}
