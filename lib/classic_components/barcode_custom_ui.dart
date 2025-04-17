import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../ui/preview/barcodes_result_preview.dart';
import '../utility/utils.dart';

/// A widget that demonstrates integrating a classical barcode scanner.
class BarcodeScannerWidget extends StatefulWidget {
  const BarcodeScannerWidget({Key? key}) : super(key: key);

  @override
  _BarcodeScannerWidgetState createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  /// Stream used to show live scanned results on top of the camera.
  /// Scanning stops and returns the first result, unless this is utilized.
  final resultStream = StreamController<List<BarcodeItem>>();

  // States to manage various functionalities
  bool permissionGranted = false;
  bool flashEnabled = false;
  bool showPolygon = true;
  bool flashAvailable = false;
  bool licenseIsActive = true;
  bool detectionEnabled = true;

  @override
  void initState() {
    super.initState();
    _checkPermission(); // Check for camera permission on widget initialization.
  }

  /// Shows the result on a new screen and resets scanning state after the screen is popped.
  Future<void> _showResult(List<BarcodeItem> barcodeItems) async {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
          builder: (context) => BarcodesResultPreviewWidget(barcodeItems)),
    )
        .then((_) {
      setState(() {
        detectionEnabled = true;
        showPolygon = true;
      });
    });
  }

  /// Requests camera permission from the user.
  Future<void> _checkPermission() async {
    final permissionResult = await [Permission.camera].request();
    setState(() {
      permissionGranted =
          permissionResult[Permission.camera]?.isGranted ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScanbotAppBar("Scan barcodes", showBackButton: true, context: context, actions: [_buildFlashToggleButton()]),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            _buildCameraView(), // Camera view or permission/licensing messages
            _buildResultStream(), // Overlay for displaying scanned results
          ],
        ),
      ),
    );
  }

  /// Builds the configuration for the scanner's finder overlay.
  FinderConfiguration _buildFinderConfiguration() {
    return FinderConfiguration(
      onFinderRectChange: (left, top, right, bottom) {
        // Callback to align text or widgets dynamically based on the finder’s position.
      },
      topWidget: const Center(
        child: Text(
          'Top hint text in center',
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomWidget: const Align(
        alignment: Alignment.topCenter,
        child: Text(
          'This is text in finder bottom TopCenter part',
          style: TextStyle(color: Colors.white),
        ),
      ),
      widget: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            border:
            Border.all(width: 5, color: Colors.lightBlue.withAlpha(155)),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 5, color: Colors.deepPurple),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
    );
  }

  /// Builds the configuration for the classical barcode scanner.
  BarcodeClassicScannerConfiguration
  _buildBarcodeClassicScannerConfiguration() {
    return BarcodeClassicScannerConfiguration(
      returnBarcodeImage: enableImagesInScannedBarcodesResults,
      barcodeFormatConfigurations: [BarcodeFormatConfigurationBase.barcodeFormatCommonConfiguration()],
      engineMode: BarcodeScannerEngineMode.NEXT_GEN, // Uses the latest engine for scanning.
    );
  }

  /// Builds the configuration for the selection overlay scanner.
  SelectionOverlayScannerConfiguration
  _buildSelectionOverlayScannerConfiguration() {
    return SelectionOverlayScannerConfiguration(
      overlayEnabled: showPolygon,
      automaticSelectionEnabled: false,
      textFormat: BarcodeOverlayTextFormat.CODE,
      polygonColor: Colors.green,
      textColor: Colors.white,
      textContainerColor: Colors.grey,
      onBarcodeClicked: (barcode) async {

        /// if you want to use image later call encodeImages() to save in buffer
        if(enableImagesInScannedBarcodesResults)
          barcode.encodeImages();

        await _showResult([barcode]);
      },
    );
  }

  /// Builds the camera view widget, handling licensing and permissions.
  Widget _buildCameraView() {
    if (!licenseIsActive)
      return _buildLicenseInactiveView(); // Handle inactive license state.
    if (!permissionGranted)
      return _buildPermissionNotGrantedView(); // Handle no permission state.

    return BarcodeScannerCamera(
      configuration: BarcodeCameraConfiguration(
        flashEnabled: flashEnabled,

        detectionEnabled: detectionEnabled,
        scannerConfiguration: _buildBarcodeClassicScannerConfiguration(),
        cameraZoomFactor: 0.01,
        overlayConfiguration: _buildSelectionOverlayScannerConfiguration(),
        finder: _buildFinderConfiguration(),
      ),
      barcodeListener: (barcodeItems) async {
        // Use update function to show result overlay on top of the camera or
        // resultStream.add(barcodeItems);

        /// if you want to use image later call encodeImages() to save in buffer
        if(enableImagesInScannedBarcodesResults)
          barcodeItems.forEach((item) {
            item.encodeImages();
          });

        // this to return result to preview screen
        await _showResult(barcodeItems);
      }, // Handle barcode scanning results.
      errorListener: (licenseStatus) {
        setState(() {
          licenseIsActive = false;
        });
        Logger.root.severe(licenseStatus);
      },
      onCameraPreviewStarted: (isFlashAvailable) {
        setState(() {
          flashAvailable = isFlashAvailable;
        });
      },
      onHeavyOperationProcessing: (show) {},
    );
  }

  Widget _buildFlashToggleButton() {
    if (!flashAvailable) return Container();

    return IconButton(
      onPressed: () {
        setState(() {
          flashEnabled = !flashEnabled;
        });
      },
      icon: Icon(flashEnabled ? Icons.flash_on : Icons.flash_off),
    );
  }

  /// Displays a view indicating that the license is inactive.
  Widget _buildLicenseInactiveView() {
    return _buildCenteredMessage('License is No more active');
  }

  /// Displays a view indicating that permissions have not been granted.
  Widget _buildPermissionNotGrantedView() {
    return _buildCenteredMessage('Permissions not granted');
  }

  Widget _buildCenteredMessage(String message) {
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

  /// Builds a stream builder that listens to scanning results and displays them.
  Widget _buildResultStream() {
    return StreamBuilder<List<BarcodeItem>>(
      stream: resultStream.stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return Container();

        return Stack(
          children: [
            _buildBarcodeListView(snapshot.data),
          ],
        );
      },
    );
  }

  /// Creates a ListView to display the scanned barcode texts.
  Widget _buildBarcodeListView(List<BarcodeItem>? data) {
    return ListView.builder(
      itemCount: data?.length ?? 0,
      itemBuilder: (context, index) {
        var barcode = data?[index].text ?? '';
        return Container(
          color: Colors.white60,
          child: Text(barcode),
        );
      },
    );
  }
}