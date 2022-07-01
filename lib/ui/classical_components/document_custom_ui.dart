import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_sdk/classical_components/classical_camera.dart';
import 'package:scanbot_sdk/classical_components/document_camera.dart';
import 'package:scanbot_sdk/classical_components/document_live_detection.dart';
import 'package:scanbot_sdk/classical_components/document_scanner_configuration.dart';
import 'package:scanbot_sdk/classical_components/hint.dart';
import 'package:scanbot_sdk/document_scan_data.dart';
import 'package:scanbot_sdk/json/common_data.dart' as common;

import '../../main.dart';
import '../pages_widget.dart';

/// This is an example screen of how to integrate new classical barcode scanner component
class DocumentScannerWidget extends StatefulWidget {
  const DocumentScannerWidget({Key? key}) : super(key: key);

  @override
  _DocumentScannerWidgetState createState() => _DocumentScannerWidgetState();
}

class _DocumentScannerWidgetState extends State<DocumentScannerWidget> {
  /// this stream only used if you need to show live scanned results on top of the camera
  /// otherwise we stop scanning and return first result out of the screen
  final resultStream = StreamController<common.Page>();
  final detectionStatusStream = StreamController<DetectionResult>();
  ScanbotCameraController? controller;
  late DocumentCameraLiveDetector liveDetector;
  bool permissionGranted = false;
  bool flashEnabled = true;
  bool autoSnappingEnabled = true;
  bool flashAvailable = false;
  bool showProgressBar = false;
  bool licenseIsActive = true;

  _DocumentScannerWidgetState() {
    liveDetector = DocumentCameraLiveDetector(
      // Subscribe to the success result of the scanning end error handling
      snapListener: (page) {
        /// Use update function to show result overlay on top of the camera or
        resultStream.add(page);

        /// this to return result to screen caller
        // liveDetector
        //     .pauseDetection(); //also we can pause detection after success immediately to prevent it from sending new sucсess results
        // Navigator.pop(context, [page]);
        //
      },
      //Error listener, will inform if there is problem with the license on opening of the screen // and license expiration on android, ios wil be enabled a bit later
      errorListener: (error) {
        setState(() {
          licenseIsActive = false;
        });
        Logger.root.severe(error.toString());
      },
      documentContourListener: (DocumentContourScanningResult result) {
        detectionStatusStream.add(result.detectionResult);
      },
    );
  }

  void checkPermission() async {
    // Don't forget to update ios Podfile according to the `permission_handler` official installation guide!! https://pub.dev/packages/permission_handler
    final permissionResult = await [Permission.camera].request();
    setState(() {
      permissionGranted =
          permissionResult[Permission.camera]?.isGranted ?? false;
    });
  }

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Scan barcodes',
          style: TextStyle(
            inherit: true,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                liveDetector
                    .setAutoSnappingEnabled(!autoSnappingEnabled)
                    .then((value) => {
                          setState(() {
                            autoSnappingEnabled = !autoSnappingEnabled;
                          })
                        });
                liveDetector
                    .setPolygonViewVisible(!autoSnappingEnabled)
                    .then((value) => {});
              },
              icon: Icon(autoSnappingEnabled
                  ? Icons.auto_mode_outlined
                  : Icons.disabled_by_default)),
          if (flashAvailable)
            IconButton(
                onPressed: () {
                  controller?.setFlashEnabled(!flashEnabled).then((value) => {
                        setState(() {
                          flashEnabled = !flashEnabled;
                        })
                      });
                },
                icon: Icon(flashEnabled ? Icons.flash_on : Icons.flash_off)),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Check permission and show some placeholder if its not granted, or show camera otherwise
          licenseIsActive
              ? permissionGranted
                  ? Stack(
                      children: [
                        DocumentScannerCamera(
                          cameraDetector: liveDetector,
                          // Camera on the bottom of the stack, should not be rebuild on each update of the stateful widget
                          configuration: DocumentCameraConfiguration(
                              flashEnabled: flashEnabled, //initial flash state
                              // Initial configuration for the scanner itself
                              scannerConfiguration:
                                  DocumentClassicScannerConfiguration(
                                      // ignoreBadAspectRatio: false,
                                      autoSnapEnabled: autoSnappingEnabled,
                                      //initial autosnapping
                                      //acceptedAngleScore: 35,
                                      //acceptedSizeScore: 0.75,
                                      /*  requiredAspectRatios: [
                                    const PageAspectRatio(
                                        width: 1.0, height: 1.0)
                                  ],*/
                                      detectDocumentAfterSnap: true,
                                      autoSnapSensitivity: 0.5),
                              contourConfiguration: ContourConfiguration(
                                strokeOkColor: Colors.red,
                                fillOkColor: Colors.red.withAlpha(150),
                                strokeColor: Colors.blue,
                                fillColor: Colors.blue.withAlpha(150),
                                cornerRadius: 35,
                                strokeWidth: 10,
                                autoSnapProgressStrokeColor: Colors.greenAccent,
                                autoSnapProgressEnabled: true,
                                autoSnapProgressStrokeWidth: 5,
                              )),
                          onWidgetReady: (controller) {
                            // Once your camera initialized you are now able to control camera parameters
                            this.controller = controller;
                            // This option uses to check from platform whether flash is available and display control button
                            controller.isFlashAvailable().then((value) => {
                                  setState(() {
                                    flashAvailable = value;
                                  })
                                });
                          },
                          onHeavyOperationProcessing: (show) {
                            showProgressBar = show;
                          },
                        ),
                        StreamBuilder<DetectionResult>(
                            stream: detectionStatusStream.stream,
                            builder: (context, snapshot) {
                              if (snapshot.data == null) {
                                return Container();
                              }

                              return SizedBox(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green.withAlpha(150),
                                        borderRadius:
                                            const BorderRadiusDirectional.all(
                                                Radius.circular(5)),
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                          color: Colors.green.withAlpha(150),
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          snapshot.data?.name ?? "",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  );
                            }),
                      ],
                    )
                  : Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: const Text(
                        'Permissions not granted',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: const Text(
                    'License is No more active',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

          //result content on the top of the scanner as a stream builder, to optimize rebuilding of the widget on each success
          StreamBuilder<common.Page>(
              stream: resultStream.stream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }
                return SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Align(
                      child: SizedBox(
                          width: 100,
                          height: 200,
                          child: FadeOutHintView(child: PagePreview(page: snapshot.data!))),
                      alignment: Alignment.bottomRight,
                    ));
              }),
          showProgressBar
              ? const Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class PagePreview extends StatelessWidget {
  final common.Page page;

  const PagePreview({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var documentPreviewFile = File.fromUri(page.documentPreviewImageFileUri!);
    var originalPreviewFile = File.fromUri(page.originalPreviewImageFileUri!);
    var file = documentPreviewFile.existsSync() ? documentPreviewFile : originalPreviewFile;
    var imageUri = documentPreviewFile.existsSync() ? page.documentPreviewImageFileUri! : page.originalPreviewImageFileUri!;
    if (file.existsSync() == true) {
      if (shouldInitWithEncryption) {
        return SizedBox(
          height: 200,
          child: EncryptedPageWidget(imageUri),
        );
      } else {
        return SizedBox(
          height: 200,
          child: PageWidget(imageUri),
        );
      }
    }
    return Container();
  }
}