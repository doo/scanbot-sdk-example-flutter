import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;
import '../../pages_repository.dart';

/// This screen demonstrates how to integrate the classical cropping component
class CroppingScreenWidget extends StatefulWidget {
  const CroppingScreenWidget({Key? key, required this.page}) : super(key: key);
  final sdk.Page page;

  @override
  _CroppingScreenWidgetState createState() => _CroppingScreenWidgetState();
}

class _CroppingScreenWidgetState extends State<CroppingScreenWidget> {
  final PageRepository _pageRepository = PageRepository();
  late sdk.Page currentPage;
  bool showProgressBar = false;
  bool doneButtonEnabled = true;
  CroppingController? croppingController;

  @override
  void initState() {
    super.initState();
    currentPage = widget.page;
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
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _handleNextPage,
      child: const Icon(Icons.navigate_next),
    );
  }

  Future<void> _handleNextPage() async {
    setState(() {
      showProgressBar = true;
    });

    final nextPage = await _pageRepository.nextPage(currentPage);

    setState(() {
      showProgressBar = false;
      currentPage = nextPage;
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      title: const Text(
        'Crop document',
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        if (doneButtonEnabled)
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: cropAndPop,
          ),
      ],
    );
  }

  Widget _buildCroppingWidget() {
    return ScanbotCroppingWidget(
      page: currentPage,
      onViewReady: (controller) {
        croppingController = controller;
      },
      onHeavyOperationProcessing: (isProcessing) {
        setState(() {
          showProgressBar = isProcessing;
        });
      },
      edgeColor: Colors.red,
      edgeColorOnLine: Colors.blue,
      anchorPointsColor: Colors.amberAccent,
      borderInsets: sdk.Insets.all(16),
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
          _buildBottomBarButton('Rotate Cw', _rotateImage),
        ],
      ),
    );
  }

  Widget _buildBottomBarButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: doneButtonEnabled ? onPressed : null,
      child: Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
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

  Future<sdk.Page> proceedImage(
      sdk.Page page, CroppingPolygon croppingResult) async {
    return await ScanbotSdk.cropAndRotatePage(
      page,
      croppingResult.polygon,
      croppingResult.rotationTimesCw,
    );
  }

  Future<void> cropAndPop() async {
    setState(() {
      showProgressBar = true;
    });

    var croppingResult = await croppingController?.getPolygon();

    setState(() {
      showProgressBar = false;
    });

    if (croppingResult != null) {
      var newPage = await proceedImage(currentPage, croppingResult);
      Navigator.of(context).pop(newPage);
    }
  }
}