import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_sdk/classical_components/classical_camera.dart';
import 'package:scanbot_sdk/classical_components/document_camera.dart';
import 'package:scanbot_sdk/classical_components/document_live_detection.dart';
import 'package:scanbot_sdk/classical_components/document_scanner_configuration.dart';
import 'package:scanbot_sdk/document_scan_data.dart';
import 'package:scanbot_sdk/json/common_data.dart' as common;

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
        //resultStream.add(scanningResult);

        /// this to return result to screen caller
        liveDetector
            .pauseDetection(); //also we can pause detection after success immediately to prevent it from sending new sucсess results
        Navigator.pop(context, [page]);

        print(page.toJson().toString());
      },
      //Error listener, will inform if there is problem with the license on opening of the screen // and license expiration on android, ios wil be enabled a bit later
      errorListener: (error) {
        setState(() {
          licenseIsActive = false;
        });
        Logger.root.severe(error.toString());
      },
      documentContourListener: (DocumentContourScanningResult result) {
        Logger.root.severe(result.detectionResult.toString());
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
          // IconButton(
          //     onPressed: () {
          //       liveDetector
          //           .setAutoSnappingEnabled(!autoSnappingEnabled)
          //           .then((value) => {
          //                 setState(() {
          //                   autoSnappingEnabled = !autoSnappingEnabled;
          //                 })
          //               });
          //       liveDetector
          //           .setPolygonViewVisible(!autoSnappingEnabled)
          //           .then((value) => {});
          //     },
          //     icon: Icon(autoSnappingEnabled
          //         ? Icons.auto_mode_outlined
          //         : Icons.disabled_by_default)),
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
                  ? DocumentScannerCamera(
                      cameraDetector: liveDetector,
                      // Camera on the bottom of the stack, should not be rebuild on each update of the stateful widget
                      configuration: DocumentCameraConfiguration(
                          flashEnabled: flashEnabled, //initial flash state
                          // Initial configuration for the scanner itself
                          scannerConfiguration:
                              DocumentClassicScannerConfiguration(
                            // ignoreBadAspectRatio: false,
                            autoSnappingEnabled: autoSnappingEnabled,
                            //initial autosnapping
                            //acceptedAngleScore: 35,
                            //acceptedSizeScore: 0.75,
                            /*  requiredAspectRatios: [
                                    const PageAspectRatio(
                                        width: 1.0, height: 1.0)
                                  ],*/
                            detectDocumentAfterSnap: true,
                            //autoSnappingSensitivity: 0.66
                          ),
                          contourConfiguration: ContourConfiguration(
                              polygonViewVisible: true,
                              colorStroke: Colors.blue,
                              colorFill: Colors.blue.withAlpha(150),
                              cornerRadius: 35,
                              strokeWidth: 10)),
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
                return Stack(
                  children: const [],
                );
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
