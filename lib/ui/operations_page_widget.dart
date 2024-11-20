import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;

import 'package:scanbot_sdk_example_flutter/ui/progress_dialog.dart';
import 'package:scanbot_sdk_example_flutter/utility/utils.dart';

import '../classic_components/cropping_custom_ui.dart';
import '../main.dart';
import '../storage/pages_repository.dart';
import 'filter_page/filter_page_widget.dart';
import 'pages_widget.dart';

class PageOperations extends StatefulWidget {
  final sdk.Page initialPage;

  PageOperations(this.initialPage);

  @override
  _PageOperationsState createState() => _PageOperationsState();
}

class _PageOperationsState extends State<PageOperations> {
  final PageRepository _pageRepository = PageRepository();
  late sdk.Page _page;
  bool showProgressBar = false;

  @override
  void initState() {
    super.initState();
    _page = widget.initialPage;
  }

  Future<void> _updatePage(sdk.Page pageUpdated) async {
    setState(() {
      showProgressBar = true;
    });
    await _pageRepository.updatePage(pageUpdated);
    setState(() {
      showProgressBar = false;
      _page = pageUpdated;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine which widget to display based on encryption requirement
    final imageUri = _page.documentPreviewImageFileUri!;
    final pageView = shouldInitWithEncryption
        ? EncryptedPageWidget(imageUri)
        : PageWidget(imageUri);

    return Scaffold(
      appBar: AppBar(
        // Customize the icon theme and background color of the app bar
        iconTheme: const IconThemeData(
          color: Colors.black, // Change icon color here
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Image Preview',
          style: TextStyle(color: Colors.black), // Title text color
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => _analyzeQuality(), // Action for analyzing quality
              child: const Icon(
                Icons.image_search,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: pageView),
                ),
              ),
            ],
          ),
          // Show progress bar if `showProgressBar` is true
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
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildOptionButton(
              icon: Icons.crop,
              label: 'RTU Crop',
              onPressed: () => _startCroppingScreen(),
            ),
            _buildOptionButton(
              icon: Icons.crop,
              label: 'Classic Crop',
              onPressed: () => _startCustomUiCroppingScreen(),
            ),
            _buildOptionButton(
              icon: Icons.filter,
              label: 'Filter',
              onPressed: () => _showFilterPage(),
            ),
            _buildOptionButton(
              icon: Icons.delete,
              label: 'Delete',
              iconColor: Colors.red,
              labelColor: Colors.red,
              onPressed: () => _deletePage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color iconColor = Colors.black,
    Color labelColor = Colors.black,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: iconColor),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: labelColor),
          ),
        ],
      ),
    );
  }

  Future<void> _deletePage() async {
    try {
      await ScanbotSdk.deletePage(_page);
      await _pageRepository.removePage(_page);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showFilterPage() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    var resultPage = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PageFiltering(_page)),
    );

    if (resultPage != null) {
      await _updatePage(resultPage);
    }
  }

  Future<void> _startCroppingScreen() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      final config = CroppingScreenConfiguration(
        bottomBarBackgroundColor: Colors.blue,
        // polygonColor: Colors.yellow,
        // polygonLineWidth: 10,
        cancelButtonTitle: 'Cancel',
        doneButtonTitle: 'Save',
        // See further configs ...
      );
      final result = await ScanbotSdkUi.startCroppingScreen(_page, config);
      if (isOperationSuccessful(result) && result.page != null) {
        await _updatePage(result.page!);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _startCustomUiCroppingScreen() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      var newPage = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => CroppingScreenWidget(page: _page)),
      );
      await _updatePage(newPage!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _analyzeQuality() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    var dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    dialog.style(message: 'Analysing ...');
    dialog.show();

    try {
      final result = await ScanbotSdk.analyzeQualityOfDocument(_page,
          analyzerImageSizeLimit: sdk.Size(width: 2500, height: 2500));

      await showAlertDialog(
        context,
        'Document Quality value is: ${result.documentQuality}',
        title: 'Result',
      );
    } catch (e) {
      Logger.root.severe(e);
    } finally {
      dialog.hide();
    }
  }
}
