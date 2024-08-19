import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;
import 'package:scanbot_sdk_example_flutter/ui/classical_components/cropping_custom_ui.dart';
import 'package:scanbot_sdk_example_flutter/ui/progress_dialog.dart';
import 'package:scanbot_sdk_example_flutter/utility/utils.dart';

import '../main.dart';
import '../pages_repository.dart';
import 'filter_page/filter_page_widget.dart';
import 'pages_widget.dart';

class PageOperations extends StatefulWidget {
  final sdk.Page _page;

  PageOperations(this._page);

  @override
  _PageOperationsState createState() => _PageOperationsState();
}

class _PageOperationsState extends State<PageOperations> {
  final PageRepository _pageRepository = PageRepository();
  late sdk.Page _page;
  bool showProgressBar = false;

  @override
  void initState() {
    _page = widget._page;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Determine which widget to display based on encryption requirement
    Widget pageView = shouldInitWithEncryption
        ? EncryptedPageWidget(_page.documentImageFileUri!)
        : PageWidget(_page.documentImageFileUri!);

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
              onTap: () =>
                  _analyzeQuality(_page), // Action for analyzing quality
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
              onPressed: () => _startCroppingScreen(_page),
            ),
            _buildOptionButton(
              icon: Icons.crop,
              label: 'Classic Crop',
              onPressed: () => _startCustomUiCroppingScreen(_page),
            ),
            _buildOptionButton(
              icon: Icons.filter,
              label: 'Filter',
              onPressed: () => _showFilterPage(_page),
            ),
            _buildOptionButton(
              icon: Icons.delete,
              label: 'Delete',
              iconColor: Colors.red,
              labelColor: Colors.red,
              onPressed: () => _deletePage(_page),
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

  Future<void> _deletePage(sdk.Page page) async {
    try {
      await ScanbotSdk.deletePage(page);
      await _pageRepository.removePage(page);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showFilterPage(sdk.Page page) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    final resultPage = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PageFiltering(page)),
    );
    if (resultPage != null) {
      await _updatePage(resultPage);
    }
  }

  Future<void> _updatePage(sdk.Page page) async {
    setState(() {
      showProgressBar = true;
    });
    await _pageRepository.updatePage(page);
    setState(() {
      showProgressBar = false;
      _page = page;
    });
  }

  Future<void> _startCroppingScreen(sdk.Page page) async {
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
      final result = await ScanbotSdkUi.startCroppingScreen(page, config);
      if (isOperationSuccessful(result) && result.page != null) {
        await _updatePage(result.page!);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _startCustomUiCroppingScreen(sdk.Page page) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      var newPage = await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => CroppingScreenWidget(page: page)),
      );
      await _updatePage(newPage!);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _analyzeQuality(sdk.Page page) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    var dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true);
    dialog.style(message: 'Analysing ...');
    dialog.show();

    try {
      final result = await ScanbotSdk.analyzeQualityOfDocument(page,
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
