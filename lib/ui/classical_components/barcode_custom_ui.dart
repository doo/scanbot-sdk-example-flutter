import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_sdk/barcode_scanning_data.dart';
import 'package:scanbot_sdk/classical_components/barcode_live_detection.dart';
import 'package:scanbot_sdk/classical_components/barcode_scanner_configuration.dart';
import 'package:scanbot_sdk/classical_components/camera_configuration.dart';
import 'package:scanbot_sdk/classical_components/classical_camera.dart';
import 'package:scanbot_sdk/common_data.dart';

class BarcodeScannerWidget extends StatefulWidget {
  const BarcodeScannerWidget({Key? key}) : super(key: key);

  @override
  _BarcodeScannerWidgetState createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  final resultStream = StreamController<BarcodeScanningResult>();
  ScanbotCameraController? controller;

  void updateUi(BarcodeScanningResult scanningResult) {
    resultStream.add(scanningResult);
  }

  bool permissionGranted = false;
  bool flashEnabled = true;

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
    final barcodeCameraLiveDetector = BarcodeCameraLiveDetector(
      // Initial configuration for the scanner itself
      configuration: BarcodeClassicalScannerConfiguration(
          barcodeFormats: [BarcodeFormat.QR_CODE],
          engineMode: EngineMode.NextGen),
      // Subscribe to the successful result of the scanning end error handling
      barcodeListener: (scanningResult) {
        updateUi(scanningResult);
        print(scanningResult.toJson().toString());
      },
      errorListener: (error) {
        Logger.root.severe(error.toString());
      },
    );

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
          // Camera on the bottom of the stack, should not be rebuild on each update of the stateful widget
          permissionGranted
              ? ScanbotCamera(
            detector: barcodeCameraLiveDetector,
            // Here we set initial configurations of the camera
            configuration: BarcodeWidgetConfiguration(
                flashEnabled: flashEnabled,
                finder: FinderConfiguration(
                    finderLineWidth: 20,
                    finderVerticalOffset: 100,
                    finderLineColor: Colors.deepPurpleAccent,
                    finderBackgroundColor: Colors.amber.withAlpha(150),
                    finderAspectRatio:
                    FinderAspectRatio(width: 100, height: 100))),
            onWidgetReady: (controller) {
              // Once your camera initialized you are now able to control camera parameters
              this.controller = controller;
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
                return ListView.builder(
                    itemCount: snapshot.data?.barcodeItems.length ?? 0,
                    itemBuilder: (context, index) {
                      var barcode =
                          snapshot.data?.barcodeItems[index].text ?? '';
                      return Container(
                          color: Colors.white60, child: Text(barcode));
                    });
              }),
        ],
      ),
    );
  }
}
