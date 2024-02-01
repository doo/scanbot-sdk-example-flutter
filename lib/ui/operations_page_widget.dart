import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;
import 'package:scanbot_sdk_example_flutter/ui/classical_components/cropping_custom_ui.dart';
import 'package:scanbot_sdk_example_flutter/ui/utils.dart';

import '../main.dart';
import '../pages_repository.dart';
import 'filter_page_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    Widget pageView;
    if (shouldInitWithEncryption) {
      pageView = EncryptedPageWidget(_page.documentImageFileUri!);
    } else {
      pageView = PageWidget(_page.documentImageFileUri!);
    }
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Image Preview',
          style: TextStyle(inherit: true, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                _analyzeQuality(_page);
              },
              child: const Icon(
                Icons.image_search,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
                child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Center(child: pageView))),
          ],
        ),
        showProgressBar
            ? const Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                  ),
                ),
              )
            : Container()
      ]),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsetsDirectional.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              onPressed: () {
                _startCroppingScreen(_page);
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.crop),
                  Text(
                    'RTU Crop',
                    style: TextStyle(inherit: true, color: Colors.black),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                _startCustomUiCroppingScreen(_page);
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.crop),
                  Text(
                    'Classic Crop',
                    style: TextStyle(inherit: true, color: Colors.black),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                _showFilterPage(_page);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.filter),
                  Container(height: 4),
                  const Text(
                    'Filter',
                    style: TextStyle(inherit: true, color: Colors.black),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                _deletePage(_page);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.delete, color: Colors.red),
                  Container(width: 4),
                  const Text(
                    'Delete',
                    style: TextStyle(inherit: true, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
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
    }
  }
}
