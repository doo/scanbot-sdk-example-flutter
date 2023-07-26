import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;

import '../../main.dart';
import '../barcode_preview.dart';
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
        // pause whole detection process if you are going to show result on other screen
        // comment this line if you want to show result on top of the camera (AR overlay mode)
        barcodeCameraDetector.pauseDetection();

        /// Use update function to show result overlay on top of the camera or
        //resultStream.add(scanningResult);
        //liveDetector.resumeDetection(); // resume detection for next snap

        /// for returning scanning result back
        // Navigator.pop(context, scanningResult);

        // for showing result in next screen in stack
        // comment this line if you want to show result on top of the camera (AR overlay mode)
        showResult(scanningResult);
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

  Future<void> showResult(BarcodeScanningResult scanningResult) async {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
          builder: (context) => BarcodesResultPreviewWidget(scanningResult)),
    )
        .then((value) {
      ///resume camera when going back to camera from other screen
      barcodeCameraDetector.resumeDetection();
    });
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
    var finderConfiguration = FinderConfiguration(
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
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.lightBlue.withAlpha(155),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
          ),
        ),
        // The shape by which background will be clipped and which will be presented as finder hole
        decoration: BoxDecoration(
            border: Border.all(
              width: 5,
              color: Colors.deepPurple,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        backgroundColor: Colors.amber.withAlpha(150),
        finderAspectRatio: sdk.AspectRatio(width: 3, height: 2));

    var barcodeClassicScannerConfiguration = BarcodeClassicScannerConfiguration(
      barcodeFormats: PredefinedBarcodes.allBarcodeTypes(),
      //[BarcodeFormat.QR_CODE] for one barcode type
      engineMode: EngineMode.NEXT_GEN,
      additionalParameters: BarcodeAdditionalParameters(
          msiPlesseyChecksumAlgorithm: MSIPlesseyChecksumAlgorithm.MOD_11_NCR,
          enableGS1Decoding: true),
      // get full size image of document with successfully scanned barcode
      // barcodeImageGenerationType:
      // BarcodeImageGenerationType.CAPTURED_IMAGE
    );

    var selectionOverlayScannerConfiguration =
        SelectionOverlayScannerConfiguration(
      overlayEnabled: true,
      textFormat: BarcodeOverlayTextFormat.CODE,
      polygonColor: Colors.green,
      textColor: Colors.white,
      textContainerColor: Colors.grey,
      polygonStrokeWidth: 4,
      polygonCornerRadius: 2,
      onBarcodeClicked: (barcode) {
        // pause detection if you want to show result on other screen
        barcodeCameraDetector.pauseDetection();
        showResult(BarcodeScanningResult([barcode]));
      },
    );
    var barcodeCameraConfiguration = BarcodeCameraConfiguration(
      flashEnabled: flashEnabled, //initial flash state
      // Initial configuration for the scanner itself
      scannerConfiguration: barcodeClassicScannerConfiguration,

      // uncomment this line if you want to show result on top of the camera (AR overlay mode)
      // (please also see other comments related to this mode above)
      // overlayConfiguration: selectionOverlayScannerConfiguration,

      finder: finderConfiguration,
    );
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
                        if (mounted)
                          {
                            setState(() {
                              flashEnabled = !flashEnabled;
                            })
                          }
                      });
                },
                icon: Icon(flashEnabled ? Icons.flash_on : Icons.flash_off))
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            // Check permission and show some placeholder if its not granted, or show camera otherwise
            licenseIsActive
                ? permissionGranted
                    ? BarcodeScannerCamera(
                        cameraDetector: barcodeCameraDetector,
                        // Camera on the bottom of the stack, should not be rebuild on each update of the stateful widget
                        configuration: barcodeCameraConfiguration,
                        onWidgetReady: (controller) {
                          // Once your camera initialized you are now able to control camera parameters
                          this.controller = controller;
                          // This option uses to check from platform whether flash is available and display control button
                          controller.isFlashAvailable().then((value) => {
                                if (mounted)
                                  {
                                    setState(() {
                                      flashAvailable = value;
                                    })
                                  }
                              });
                        },
                        onCameraPreviewStarted: () {},
                        onHeavyOperationProcessing: (show) {
                          setState(() {
                            showProgressBar = show;
                          });
                        },
                      )
                    : Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: const Text(
                          'Permissions not granted',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                : Container(
                    color: Colors.white,
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
                      pageView = EncryptedPageWidget(
                          (snapshot.data?.barcodeImageURI)!);
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
      ),
    );
  }
}
