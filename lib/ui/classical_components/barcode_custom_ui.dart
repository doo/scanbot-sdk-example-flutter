import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_sdk/barcode_scanning_data.dart';
import 'package:scanbot_sdk/classical_components/barcode_camera.dart';
import 'package:scanbot_sdk/classical_components/barcode_live_detection.dart';
import 'package:scanbot_sdk/classical_components/barcode_scanner_configuration.dart';
import 'package:scanbot_sdk/classical_components/camera_configuration.dart';
import 'package:scanbot_sdk/classical_components/classical_camera.dart';
import 'package:scanbot_sdk/common_data.dart';

import '../../main.dart';
import '../pages_widget.dart';

class BarcodeScannerWidget extends StatefulWidget {
  const BarcodeScannerWidget({Key? key}) : super(key: key);

  @override
  _BarcodeScannerWidgetState createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  final resultStream = StreamController<BarcodeScanningResult>();
  ScanbotCameraController? controller;
  late BarcodeCameraLiveDetector barcodeCameraDetector;
  bool permissionGranted = false;
  bool flashEnabled = false;
  bool showProgressBar = false;

  _BarcodeScannerWidgetState() {
    barcodeCameraDetector = BarcodeCameraLiveDetector(
      // Subscribe to the success result of the scanning end error handling
      barcodeListener: (scanningResult) {
        // Use update function to show result overlay on top of the camera or
        //resultStream.add(scanningResult);

        // this to return result to screen caller
        barcodeCameraDetector
            .pauseDetection(); //also we can pause detection after success immediately to prevent it from sending new sucсess results
        Navigator.pop(context, scanningResult);

        print(scanningResult.toJson().toString());
      },
      errorListener: (error) {
        Logger.root.severe(error.toString());
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
        iconTheme: IconThemeData(),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
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
                controller?.setFlashEnabled(!flashEnabled);
                setState(() {
                  flashEnabled = !flashEnabled;
                });
              },
              icon: Icon(flashEnabled ? Icons.flash_on : Icons.flash_off))
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Check permission and show some placeholder if its not granted, or show camera otherwise
          permissionGranted
              ? BarcodeScannerCamera(
                  cameraDetector: barcodeCameraDetector,
                  // Camera on the bottom of the stack, should not be rebuild on each update of the stateful widget
                  configuration: BarcodeCameraConfiguration(
                    flashEnabled: flashEnabled,
                    // Initial configuration for the scanner itself
                    scannerConfiguration: BarcodeClassicScannerConfiguration(
                      barcodeFormats: [BarcodeFormat.QR_CODE],
                      engineMode: EngineMode.NextGen,
                      // barcodeImageGenerationType:
                      //   BarcodeImageGenerationType.CAPTURED_IMAGE
                    ),
                    finder: FinderConfiguration(
                        topWidget: Center(
                            child: Text(
                          'Top hint text in centre',
                          style: TextStyle(color: Colors.white),
                        )),
                        bottomWidget: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              'This is text in finder bottom TopCenter  part',
                              style: TextStyle(color: Colors.white),
                            )),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 5,
                              color: Colors.deepPurple,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        backgroundColor: Colors.amber.withAlpha(150),
                        finderVerticalOffset: 0,
                        finderAspectRatio:
                            FinderAspectRatio(width: 100, height: 100)),
                  ),
                  onWidgetReady: (controller) {
                    // Once your camera initialized you are now able to control camera parameters
                    this.controller = controller;
                  },
                  onShowProgress: (show) {
                    showProgressBar = show;
                  },
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Permissions not granted',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

          //result content on the top of the scanner as a stream builder, to optimize rebuilding of the widget on each success
          StreamBuilder<BarcodeScanningResult>(
              stream: resultStream.stream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }

                Widget pageView;
                if (snapshot.data?.barcodeImageURI != null) {
                  if (shouldInitWithEncryption) {
                    pageView =
                        EncryptedPageWidget((snapshot.data?.barcodeImageURI)!);
                  } else {
                    pageView = PageWidget((snapshot.data?.barcodeImageURI)!);
                  }
                } else {
                  pageView = Container();
                }

                return Stack(
                  children: [
                    ListView.builder(
                        itemCount: snapshot.data?.barcodeItems.length ?? 0,
                        itemBuilder: (context, index) {
                          var barcode =
                              snapshot.data?.barcodeItems[index].text ?? '';
                          return Container(
                              color: Colors.white60, child: Text(barcode));
                        }),
                    (snapshot.data?.barcodeImageURI != null)
                        ? Container(
                            width: double.infinity,
                            height: double.infinity,
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: 100,
                              height: 200,
                              child: pageView,
                            ),
                          )
                        : Container(),
                  ],
                );
              }),
          Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(onPressed: () {
              controller?.takeSnapshot();
            }),
          ),
          showProgressBar
              ? Center(
                  child: Container(
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
