import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_sdk/classical_components/camera_configuration.dart';
import 'package:scanbot_sdk/classical_components/classical_camera.dart';
import 'package:scanbot_sdk/classical_components/medical_certificate_camera.dart';
import 'package:scanbot_sdk/classical_components/medical_certificate_live_detection.dart';
import 'package:scanbot_sdk/classical_components/medical_certificate_scanner_configuration.dart';
import 'package:scanbot_sdk/json/common_data.dart';
import 'package:scanbot_sdk/mc_scanning_data.dart';

/// This is an example screen of how to integrate new classical barcode scanner component
class MedicalCertificateScannerWidget extends StatefulWidget {
  const MedicalCertificateScannerWidget({Key? key}) : super(key: key);

  @override
  _MedicalCertificateScannerWidgetState createState() =>
      _MedicalCertificateScannerWidgetState();
}

class _MedicalCertificateScannerWidgetState
    extends State<MedicalCertificateScannerWidget> {
  /// this stream only used if you need to show live scanned results on top of the camera
  /// otherwise we stop scanning and return first result out of the screen
  final resultStream = StreamController<MedicalCertificateResult>();
  ScanbotCameraController? controller;
  late MedicalCertificateCameraLiveDetector mcCameraDetector;
  bool permissionGranted = false;
  bool flashEnabled = false;
  bool flashAvailable = false;
  bool showProgressBar = false;
  bool licenseIsActive = true;

  _MedicalCertificateScannerWidgetState() {
    mcCameraDetector = MedicalCertificateCameraLiveDetector(
      // Subscribe to the success result of the scanning end error handling
      mcListener: (scanningResult) {
        if(scanningResult.recognitionSuccessful){
        /// Use update function to show result overlay on top of the camera or
        //resultStream.add(scanningResult);

        /// this to return result to screen caller
        mcCameraDetector
            .pauseDetection(); //also we can pause detection after success immediately to prevent it from sending new sucсess results
        Navigator.pop(context, scanningResult);
      }},
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
          'Scan Medical Certificate',
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
                  ? MedicalCertificateScannerCamera(
                      cameraDetector: mcCameraDetector,
                      // Camera on the bottom of the stack, should not be rebuild on each update of the stateful widget
                      configuration: MedicalCertificateCameraConfiguration(
                        flashEnabled: flashEnabled,
                        //initial flash state
                        // Initial configuration for the scanner itself
                        scannerConfiguration:
                            MedicalCertificateClassicScannerConfiguration(
                                recognizePatientInfo: true,
                                recognizeBarcode: true,
                                captureHighResolutionImage: true),
                        finder: FinderConfiguration(
                          finderAspectRatio:
                              const FinderAspectRatio(width: 3.0, height: 4.0),
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
                                'Bottom hint text in topCenter',
                                style: TextStyle(color: Colors.white),
                              )),
                          // widget that can be inserted inside finder window
                          widget: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: AspectRatio(
                                aspectRatio: 4 / 3.0,
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
                            ),
                          ),
                          // The shape by which background will be clipped and which will be presented as finder hole
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 5,
                                color: Colors.deepPurple,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          backgroundColor: Colors.amber.withAlpha(150),
                        ),
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
                        setState(() {
                          showProgressBar = show;
                        });
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
                    'License has expired',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

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
