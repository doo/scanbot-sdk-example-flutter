import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;

import '../storage/_legacy_pages_repository.dart';
import '../ui/pages_widget.dart';
import '../ui/preview/_legacy_document_preview.dart';
import '../utility/utils.dart';

/// This screen demonstrates how to integrate the classical barcode scanner component.
class DocumentScannerWidget extends StatefulWidget {
  const DocumentScannerWidget({Key? key}) : super(key: key);

  @override
  _DocumentScannerWidgetState createState() => _DocumentScannerWidgetState();
}

class _DocumentScannerWidgetState extends State<DocumentScannerWidget> {
  /// Stream used to show live scanned results on top of the camera.
  /// If not needed, scanning stops and returns the first result out of the screen.
  final resultStream = StreamController<sdk.Page>();

  /// Stream to monitor the document detection status.
  final detectionStatusStream = StreamController<DetectionStatus>();

  // Various states used within the widget.
  bool permissionGranted = false;
  bool flashEnabled = false;
  bool autoSnappingEnabled = true;
  bool flashAvailable = false;
  bool showProgressBar = false;
  bool licenseIsActive = true;

  late DocumentSnapTrigger generalSnapTrigger;
  final LegacyPageRepository _pageRepository = LegacyPageRepository();

  /// Adds scanned pages to the repository and navigates to the preview screen.
  void showPageResult(List<sdk.Page> pages) {
    _pageRepository.addPages(pages);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => LegacyDocumentPreview()),
    );
  }

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
            _buildScannedPagePreview(),
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
      if (permissionGranted && licenseIsActive)
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
    if (!licenseIsActive) {
      return _buildErrorMessage('License is no longer active');
    }

    if (!permissionGranted) {
      return _buildErrorMessage('Permissions not granted');
    }

    return Stack(
      children: [
        DocumentScannerCamera(
          snapListener: (page) {
            resultStream.add(page);
            showPageResult([page]);
          },
          errorListener: (error) {
            if (mounted) {
              setState(() {
                licenseIsActive = false;
              });
            }
            Logger.root.severe(error.toString());
          },
          documentContourListener: (result) {
            detectionStatusStream.add(result.detectionStatus);
          },
          configuration: _buildDocumentCameraConfiguration(),
          onCameraPreviewStarted: (snapTrigger, isFlashAvailable) {
            if (mounted) {
              setState(() {
                generalSnapTrigger = snapTrigger;
                flashAvailable = isFlashAvailable;
              });
            }
          },
          onHeavyOperationProcessing: (show) {
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
              child: ShutterButton(
                onPressed: () {
                  generalSnapTrigger();
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

  /// Builds the DocumentCameraConfiguration.
  DocumentCameraConfiguration _buildDocumentCameraConfiguration() {
    var documentClassicScannerConfiguration =
        DocumentClassicScannerConfiguration(
      autoSnapEnabled: autoSnappingEnabled,
      acceptedSizeScore: 75,
      detectDocumentAfterSnap: false,
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
    return StreamBuilder<DetectionStatus>(
      stream: detectionStatusStream.stream,
      builder: (context, snapshot) {
        if (snapshot.data == null || !permissionGranted || !licenseIsActive) {
          return Container();
        }
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Wrap(
              children: [
                DetectionStatusWidget(
                  status:
                      snapshot.data ?? DetectionStatus.ERROR_NOTHING_DETECTED,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the StreamBuilder for displaying scanned pages.
  Widget _buildScannedPagePreview() {
    return StreamBuilder<sdk.Page>(
      stream: resultStream.stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        return autoSnappingEnabled
            ? SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: 100,
                    height: 200,
                    child: FadeOutView(
                      key: Key(snapshot.data?.pageId ?? ""),
                      fadeDelay: const Duration(milliseconds: 500),
                      child: PagePreview(page: snapshot.data!),
                    ),
                  ),
                ),
              )
            : Container();
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
  final DetectionStatus status;

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
  final sdk.Page page;

  const PagePreview({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var documentPreviewFile = File.fromUri(page.documentPreviewImageFileUri!);
    var originalPreviewFile = File.fromUri(page.originalPreviewImageFileUri!);
    var file = documentPreviewFile.existsSync()
        ? documentPreviewFile
        : originalPreviewFile;
    var imageUri = documentPreviewFile.existsSync()
        ? page.documentPreviewImageFileUri!
        : page.originalPreviewImageFileUri!;

    if (file.existsSync()) {
      return SizedBox(
        height: 200,
        child: shouldInitWithEncryption
            ? EncryptedPageWidget(imageUri)
            : PageWidget(imageUri),
      );
    }
    return Container();
  }
}
