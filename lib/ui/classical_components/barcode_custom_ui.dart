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
import 'package:scanbot_sdk/json/common_data.dart';

import '../../main.dart';
import '../pages_widget.dart';

/// This is an example screen of how to integrate new classical barcode scanner component
class BarcodeScannerWidget extends StatefulWidget {
  const BarcodeScannerWidget({Key? key}) : super(key: key);

  @override
  _BarcodeScannerWidgetState createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  /// this stream only used if you need to show live scanned results on top of the camera
  /// otherwise we stop scanning and return first result out of the screen
  final resultStream = StreamController<BarcodeScanningResult>();
  ScanbotCameraController? controller;
  late BarcodeCameraLiveDetector barcodeCameraDetector;
  bool permissionGranted = false;
  bool flashEnabled = false;
  bool flashAvailable = false;
  bool showProgressBar = false;
  bool licenseIsActive = true;

  _BarcodeScannerWidgetState() {
    barcodeCameraDetector = BarcodeCameraLiveDetector(
      // Subscribe to the success result of the scanning end error handling
      barcodeListener: (scanningResult) {
        /// Use update function to show result overlay on top of the camera or
        //resultStream.add(scanningResult);

        /// this to return result to screen caller
        barcodeCameraDetector
            .pauseDetection(); //also we can pause detection after success immediately to prevent it from sending new sucсess results
        Navigator.pop(context, scanningResult);

        print(scanningResult.toJson().toString());
      },
      //Error listener, will inform if there is problem with the license on opening of the screen // and license expiration on android, ios wil be enabled a bit later
      errorListener: (error) {
        setState(() {
          licenseIsActive = false;
        });
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
          if (flashAvailable)
            IconButton(
                onPressed: () {
                  controller?.setFlashEnabled(!flashEnabled).then((value) => {
                        setState(() {
                          flashEnabled = !flashEnabled;
                        })
                      });
                },
                icon: Icon(flashEnabled ? Icons.flash_on : Icons.flash_off))
        ],
      ),
      body: Stack(
        children: <Widget>[
          // Check permission and show some placeholder if its not granted, or show camera otherwise

          licenseIsActive
              ? permissionGranted
                  ? BarcodeScannerCamera(
                      cameraDetector: barcodeCameraDetector,
                      // Camera on the bottom of the stack, should not be rebuild on each update of the stateful widget
                      configuration: BarcodeCameraConfiguration(
                        flashEnabled: flashEnabled, //initial flash state
                        // Initial configuration for the scanner itself
                        scannerConfiguration:
                            BarcodeClassicScannerConfiguration(
                                barcodeFormats:
                                    PredefinedBarcodes.allBarcodeTypes(),
                                //[BarcodeFormat.QR_CODE] for ine barcode type
                                engineMode: EngineMode.NextGen,
                                additionalParameters:
                                    BarcodeAdditionalParameters(
                                        msiPlesseyChecksumAlgorithm:
                                            MSIPlesseyChecksumAlgorithm
                                                .Mod11NCR,
                                        enableGS1Decoding: true)
                                // get full size image of document with successfully scanned barcode
                                // barcodeImageGenerationType:
                                // BarcodeImageGenerationType.CAPTURED_IMAGE
                                ),
                        finder: FinderConfiguration(
                            onFinderRectChange: (left, top, right, bottom) {
                              // aligning some text view to the finder dynamically by calculating its position from finder changes
                            },
                            // widget that can be inserted in the region between finder hole and top of the camera
                            topWidget: const Center(
                                child: Text(
                              'Top hint text in centre',
                              style: TextStyle(color: Colors.white),
                            )),
                            // widget that can be inserted in the region between finder hole and bottom of the camera
                            bottomWidget: const Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  'This is text in finder bottom TopCenter  part',
                                  style: TextStyle(color: Colors.white),
                                )),
                            // widget that can be inserted inside finder window
                            widget: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 5,
                                      color: Colors.lightBlue.withAlpha(155),
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                              ),
                            ),
                            // The shape by which background will be clipped and which will be presented as finder hole
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 5,
                                  color: Colors.deepPurple,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            backgroundColor: Colors.amber.withAlpha(150),
                            finderAspectRatio:
                                const FinderAspectRatio(width: 5, height: 2)),
                      ),
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
                            child: SizedBox(
                              width: 100,
                              height: 200,
                              child: pageView,
                            ),
                          )
                        : Container(),
                  ],
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
