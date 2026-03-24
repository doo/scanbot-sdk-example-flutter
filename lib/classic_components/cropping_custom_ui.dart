import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import '../utility/utils.dart';

/// This screen demonstrates how to integrate the classical cropping component
class CroppingScreenWidget extends StatefulWidget {
  const CroppingScreenWidget({Key? key, required this.documentImage})
      : super(key: key);
  final ImageRef documentImage;

  @override
  _CroppingScreenWidgetState createState() => _CroppingScreenWidgetState();
}

class _CroppingScreenWidgetState extends State<CroppingScreenWidget> {
  late ImageRef currentPage;
  bool showProgressBar = false;
  bool doneButtonEnabled = true;
  CroppingController? croppingController;

  @override
  void initState() {
    super.initState();
    currentPage = widget.documentImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildCroppingWidget(),
          if (showProgressBar) _buildProgressBar(),
        ],
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: ScanbotRedColor,
      title: const Text(
        'Crop document',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        if (doneButtonEnabled)
          IconButton(icon: const Icon(Icons.done), onPressed: cropAndPop),
      ],
    );
  }

  Widget _buildCroppingWidget() {
    return ScanbotCroppingWidget(
      documentImage: currentPage,
      onViewReady: (controller) {
        croppingController = controller;
      },
      onHeavyOperationProcessing: (isProcessing) {
        setState(() {
          showProgressBar = isProcessing;
        });
      },
      onError: (error) {
        Logger.root.severe(error.toString());
      },
      edgeColor: Colors.red,
      edgeColorOnLine: Colors.blue,
      anchorPointsColor: Colors.amberAccent,
      borderInsets: Insets.all(16),
    );
  }

  Widget _buildProgressBar() {
    return const Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(strokeWidth: 10),
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomBarButton('Reset', () => croppingController?.reset()),
          _buildBottomBarButton('Detect', () => croppingController?.detect()),
          _buildBottomBarButton('Rotate \u21BB', _rotateImage),
        ],
      ),
    );
  }

  Widget _buildBottomBarButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: doneButtonEnabled ? onPressed : null,
      child: Text(label, style: const TextStyle(color: Colors.black)),
    );
  }

  void _rotateImage() {
    if (!doneButtonEnabled) return;

    setState(() {
      doneButtonEnabled = false;
    });

    croppingController?.rotateCw().then((_) {
      setState(() {
        doneButtonEnabled = true;
      });
    });
  }

  Future<void> cropAndPop() async {
    setState(() {
      showProgressBar = true;
    });

    var croppingResult = await croppingController?.getPolygon();

    setState(() {
      showProgressBar = false;
    });

    if (croppingResult == null) {
      Navigator.of(context).pop();
      return;
    }

    final documentResult = await ScanbotSdk.document
        .createDocumentFromImageRefs(images: [currentPage]);

    if (documentResult is! Ok<DocumentData>) {
      print(documentResult.toString());
      return;
    }

    final document = documentResult.value;

    final modifiedDocumentResult = await ScanbotSdk.document.modifyPage(
      document.uuid,
      document.pages.first.uuid,
      options: ModifyPageOptions(
        rotation: croppingResult.imageRotation,
        polygon: toPointList(croppingResult.polygon),
      ),
    );

    if (modifiedDocumentResult is! Ok<DocumentData>) {
      print(modifiedDocumentResult.toString());
      return;
    }

    Navigator.of(context).pop(modifiedDocumentResult.value);
  }
}

List<Point<double>> toPointList(List<PolygonPoint> polygon) =>
    polygon.map((p) => Point<double>(p.x, p.y)).toList();
