import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

CroppingController? croppingController;

ScanbotCroppingWidget buildCroppingWidget(ImageRef documentImage) {
  return ScanbotCroppingWidget(
    documentImage:
        documentImage, // `ImageRef` document image object to be cropped
    onViewReady: (controller) {
      // Callback when the cropping view is ready
      croppingController = controller;
    },
    onHeavyOperationProcessing: (isProcessing) {
      // Callback for handling long processing operations
    },
    edgeColor: Colors.red, // Color of the cropping edges
    edgeColorOnLine: Colors.blue, // Color when edges are on the line
    anchorPointsColor: Colors.amberAccent, // Color of anchor points
    borderInsets: Insets.all(16), // Insets for the cropping borders
  );
}
