import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

DocumentScannerCamera buildDocumentScannerCamera() {
  return DocumentScannerCamera(
    configuration: DocumentCameraConfiguration(
      flashEnabled: true, // Manages the initial flash state
      scannerConfiguration: DocumentClassicScannerConfiguration(
        autoSnapEnabled: true, // Enable or disable auto-snap
        detectDocumentAfterSnap: true, // Detect document after snapping
        autoSnapSensitivity: 0.5, // Sensitivity for auto-snap
      ),
      contourConfiguration: ContourConfiguration(
        showPolygonInManualMode: false, // Hide contour polygon in manual mode
        strokeOkColor:
            Colors.red, // Color for contour strokes when detection is OK
        fillOkColor: Colors.red
            .withAlpha(150), // Fill color for contours when detection is OK
        strokeColor: Colors
            .blue, // Color for contour strokes when detection is in progress
        fillColor: Colors.blue.withAlpha(
            150), // Fill color for contours when detection is in progress
        cornerRadius: 35, // Radius for contour corners
        strokeWidth: 10, // Width of contour strokes
        autoSnapProgressStrokeColor:
            Colors.greenAccent, // Color for auto-snap progress
        autoSnapProgressEnabled: true, // Enable auto-snap progress indicator
        autoSnapProgressStrokeWidth:
            5, // Width of the auto-snap progress stroke
      ),
    ),
    onSnappedDocumentResult: (
      ImageRef originalImage,
      ImageRef? documentImage,
      DocumentDetectionResult? detectionResult,
    ) async {
      // Handle the original image and, if detectDocumentAfterSnap is enabled, the cropped image of the detected document along with the document detection result.
    },
    onError: (error) {
      // Handle errors such as licensing issues or camera errors
    },
    onFrameDetectionResult: (result) {
      // Handle document detection results
    },
    onCameraPreviewStarted: (isFlashAvailable) {
      // Perform any setup after the camera preview starts
    },
    onHeavyOperationProcessing: (show) {
      // Display a progress bar or loading indicator during long operations
    },
  );
}
