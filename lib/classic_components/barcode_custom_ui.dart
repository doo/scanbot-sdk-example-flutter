import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

class BarcodeScannerController {
  late void Function() _pause;
  late void Function() _resume;
  late ValueNotifier<bool> _pausedNotifier;

  void bind({
    required void Function() pause,
    required void Function() resume,
    required ValueNotifier<bool> pausedNotifier,
  }) {
    _pause = pause;
    _resume = resume;
    _pausedNotifier = pausedNotifier;
  }

  bool get isPaused => _pausedNotifier.value;

  Future<void> pause() async => _pause();

  Future<void> resume() async => _resume();

  Future<void> toggle() async => isPaused ? resume() : pause();
}

class BarcodeScanbotView extends StatefulWidget {
  final Future<void> Function(List<BarcodeItem> barcodes) onBarcodeDetected;
  final Widget? header;
  final Widget? footer;

  final bool useScanWindow;
  final Widget Function(bool isActive)? scannerBoxBuilder;
  final BarcodeScannerController? controller;
  final bool findBarcodeAtCenter;
  final Rect? scanWindow;

  const BarcodeScanbotView({
    super.key,
    required this.onBarcodeDetected,
    this.header,
    this.footer,
    this.useScanWindow = true,
    this.findBarcodeAtCenter = true,
    this.scannerBoxBuilder,
    this.controller,
    this.scanWindow,
  });

  @override
  State<BarcodeScanbotView> createState() => _BarcodeScannerViewState();
}

enum CameraPermissionStatus { checking, granted, denied }

class _BarcodeScannerViewState extends State<BarcodeScanbotView> {
  final ValueNotifier<bool> _isPaused = ValueNotifier(false);
  final ValueNotifier<bool> flashEnabled = ValueNotifier(false);
  final ValueNotifier<bool> flashAvailable = ValueNotifier(false);
  final ValueNotifier<CameraPermissionStatus> _permissionStatus = ValueNotifier(
    CameraPermissionStatus.checking,
  );

  bool licenseIsActive = true;
  DateTime _lastScan = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    widget.controller?.bind(
      pause: _pauseScanner,
      resume: _resumeScanner,
      pausedNotifier: _isPaused,
    );

    _checkCameraPermissions();
  }

  Future<void> _checkCameraPermissions() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      _permissionStatus.value = CameraPermissionStatus.granted;
    } else {
      final req = await Permission.camera.request();
      _permissionStatus.value = req.isGranted
          ? CameraPermissionStatus.granted
          : CameraPermissionStatus.denied;
    }
  }

  Future<void> _pauseScanner() async {
    if (!_isPaused.value) {
      _isPaused.value = true;
    }
  }

  Future<void> _resumeScanner() async {
    if (_isPaused.value) {
      _isPaused.value = false;
    }
  }

  Future<void> _handleBarcode(List<BarcodeItem> barcodes) async {
    if (_isPaused.value || barcodes.isEmpty) return;

    final now = DateTime.now();
    if (now.difference(_lastScan).inMilliseconds < 2000) return;
    _lastScan = now;
    await _show(barcodes.first.text);
    await Future.delayed(const Duration(milliseconds: 1000));
    await _pauseScanner();
    try {
      await widget.onBarcodeDetected(barcodes);
    } catch (e, s) {
      Logger.root.severe('Error handling barcode', e, s);
    }
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) await _resumeScanner();
  }

  Future<void> _show(String barcode) async {
    final focusNode = FocusNode();

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      pageBuilder: (___, _, __) {
        return Center(
          child: KeyboardActions(
            disableScroll: true,
            config: KeyboardActionsConfig(
              keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
              actions: [
                KeyboardActionsItem(
                  focusNode: focusNode,
                  toolbarButtons: [
                    (node) => TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Add"),
                        ),
                  ],
                ),
              ],
            ),
            child: Dialog(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: 'Barcode',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          controller: TextEditingController(text: barcode),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BarcodeClassicScannerConfiguration
      _buildBarcodeClassicScannerConfiguration() {
    final commonConfig = BarcodeFormatCommonConfiguration()
      ..stripCheckDigits = false
      ..minimumTextLength = 3;

    final code128Config = BarcodeFormatCode128Configuration()
      ..minimumTextLength = 5;

    return BarcodeClassicScannerConfiguration(
      barcodeFormatConfigurations: [commonConfig, code128Config],
      engineMode: BarcodeScannerEngineMode.NEXT_GEN_LOW_POWER_FAR_DISTANCE,
    );
  }

  SelectionOverlayScannerConfiguration
      _buildSelectionOverlayScannerConfiguration() {
    return SelectionOverlayScannerConfiguration(
      overlayEnabled: true,
      automaticSelectionEnabled: true,
      textFormat: BarcodeOverlayTextFormat.CODE,
      polygonColor: Colors.green,
      textColor: Colors.white,
      textContainerColor: Colors.grey,
      onBarcodeClicked: (item) async {
        if (!widget.findBarcodeAtCenter) {
          await _handleBarcode([item]);
        }
      },
    );
  }

  FinderConfiguration _buildFinderConfiguration() {
    return FinderConfiguration(
      decoration: BoxDecoration(
        border: Border.all(width: 5, color: Colors.yellow),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      bottomWidget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: const Align(
          alignment: Alignment.topCenter,
          child: Text(
            'Tap a highlighted barcode to see details',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]); // reset orientation
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CameraPermissionStatus>(
      valueListenable: _permissionStatus,
      builder: (_, status, __) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: const Text(
              'Scan Barcode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          backgroundColor: Colors.black,
          body: switch (status) {
            CameraPermissionStatus.checking => const Center(
                child: CircularProgressIndicator(),
              ),
            CameraPermissionStatus.denied => _buildPermissionDenied(context),
            CameraPermissionStatus.granted => Stack(
                children: [
                  Positioned.fill(child: _buildCameraView()),
                  if (widget.header != null) widget.header!,
                  if (widget.footer != null) widget.footer!,
                ],
              ),
          },
        );
      },
    );
  }

  Widget _buildCameraView() {
    if (!licenseIsActive) {
      return _buildLicenseInactiveView();
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _isPaused,
      builder: (_, paused, __) {
        return BarcodeScannerCamera(
          barcodeListener: (result) {
            if (result.length == 1) {
              _handleBarcode(result);
            }
          },
          configuration: BarcodeCameraConfiguration(
            detectionEnabled: !paused,
            flashEnabled: flashEnabled.value,
            scannerConfiguration: _buildBarcodeClassicScannerConfiguration(),
            cameraZoomFactor: 0.01,
            overlayConfiguration: _buildSelectionOverlayScannerConfiguration(),
            finder: widget.useScanWindow ? _buildFinderConfiguration() : null,
          ),
          errorListener: (licenseStatus) {
            licenseIsActive = false;
            Logger.root.severe(licenseStatus);
            setState(() {});
          },
          onCameraPreviewStarted: (isFlashAvailable) {
            flashAvailable.value = isFlashAvailable;
          },
          onHeavyOperationProcessing: (show) {
            // could show a loading overlay here
          },
        );
      },
    );
  }

  Widget _buildLicenseInactiveView() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.white, size: 60),
          SizedBox(height: 20),
          Text(
            'License is no longer active',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDenied(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.linked_camera_sharp, color: Colors.white, size: 60),
          const SizedBox(height: 20),
          const Text(
            'Camera permission is required to scan barcodes.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _checkCameraPermissions,
            child: const Text('Access Camera'),
          ),
        ],
      ),
    );
  }
}
