import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
import 'package:scanbot_sdk_example_flutter/ui/preview/medical_certificate_preview.dart';
import '../utility/utils.dart';

class MedicalCertificateScannerWidget extends StatefulWidget {
  const MedicalCertificateScannerWidget({Key? key}) : super(key: key);

  @override
  _MedicalCertificateScannerWidgetState createState() =>
      _MedicalCertificateScannerWidgetState();
}

class _MedicalCertificateScannerWidgetState
    extends State<MedicalCertificateScannerWidget> {
  bool permissionGranted = false;
  bool flashEnabled = false;
  bool flashAvailable = false;
  bool showProgressBar = false;
  bool licenseIsActive = true;

  @override
  void initState() {
    super.initState();
    _checkPermission(); // Check for camera permissions when initializing the widget
  }

  // Check and request camera permissions
  void _checkPermission() async {
    final permissionResult = await [Permission.camera].request();
    setState(() {
      permissionGranted =
          permissionResult[Permission.camera]?.isGranted ?? false;
    });
  }

  // Handle the scanning result and navigate to the result screen
  Future<void> _showResult(MedicalCertificateScanningResult scanningResult) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MedicalCertificatePreviewWidget(scanningResult),
      ),
    );
  }

  // Configuration for the Medical Certificate Classic Scanner
  MedicalCertificateClassicScannerConfiguration _buildScannerConfiguration() {
    return MedicalCertificateClassicScannerConfiguration(
      recognizePatientInfo: true,
      recognizeBarcode: true,
      captureHighResolutionImage: true,
    );
  }

  // Configuration for the Finder (area to scan)
  FinderConfiguration _buildFinderConfiguration() {
    return FinderConfiguration(
      // finderAspectRatio: sdk.AspectRatio(width: 3.0, height: 4.0),
      onFinderRectChange: (left, top, right, bottom) {
        // aligning some text view to the finder dynamically by calculating its position from finder changes
      },
      topWidget: const Center(
        child: Text(
          'Top hint text in centre',
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomWidget: const Align(
        alignment: Alignment.topCenter,
        child: Text(
          'Bottom hint text in topCenter',
          style: TextStyle(color: Colors.white),
        ),
      ),
      widget: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: material.AspectRatio(
            aspectRatio: 4 / 3.0,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 5,
                  color: Colors.lightBlue.withAlpha(155),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 5,
          color: Colors.deepPurple,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      backgroundColor: Colors.amber.withAlpha(150),
    );
  }

  // Configuration for the Medical Certificate Camera
  MedicalCertificateCameraConfiguration _buildCameraConfiguration() {
    return MedicalCertificateCameraConfiguration(
      flashEnabled: flashEnabled, // Initial flash state
      scannerConfiguration:
          _buildScannerConfiguration(), // Scanner configuration
      finder: _buildFinderConfiguration(), // Finder configuration
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      backgroundColor: ScanbotRedColor,
      title: const Text(
        'Scan Medical Certificate',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
      ),
      actions: [
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
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  // Error message display for permissions and license status
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            // Show camera view if license is active and permissions are granted, otherwise show an error message
            licenseIsActive
                ? permissionGranted
                    ? MedicalCertificateScannerCamera(
                        configuration: _buildCameraConfiguration(),
                        onCameraPreviewStarted: (isFlashAvailable) {
                          if (mounted) {
                            setState(() {
                              flashAvailable = isFlashAvailable;
                            });
                          }
                        },
                        mcListener: (scanningResult) {
                          if (scanningResult.scanningSuccessful!) {
                            _showResult(scanningResult);
                          }
                        },
                        errorListener: (error) {
                          if (mounted) {
                            setState(() {
                              licenseIsActive = false;
                            });
                          }
                          Logger.root.severe(error.toString());
                        },
                        onHeavyOperationProcessing: (show) {
                          setState(() {
                            showProgressBar = show;
                          });
                        },
                      )
                    : _buildErrorMessage('Permissions not granted')
                : _buildErrorMessage('License has expired'),

            // Show progress indicator if a heavy operation is in progress
            if (showProgressBar)
              const Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
