import 'package:flutter/material.dart';
import 'package:scanbot_sdk/common_data.dart' as sdk;
import 'package:scanbot_sdk/cropping_screen_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
import 'package:scanbot_sdk_example_flutter/ui/progress_dialog.dart';
import 'package:scanbot_sdk_example_flutter/ui/utils.dart';

import '../pages_repository.dart';
import 'filter_page_widget.dart';
import 'pages_widget.dart';

class PageOperations extends StatelessWidget {
  final sdk.Page _page;

  PageOperations(this._page);

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: const Text('Image Preview',
              style: TextStyle(inherit: true, color: Colors.black)),
        ),
        body: PagesPreviewWidget(_page));
  }
}

class PagesPreviewWidget extends StatefulWidget {
  final sdk.Page _page;

  PagesPreviewWidget(this._page);

  @override
  State<PagesPreviewWidget> createState() {
    return PagesPreviewWidgetState(_page);
  }
}

class PagesPreviewWidgetState extends State<PagesPreviewWidget> {
  final PageRepository _pageRepository = PageRepository();
  sdk.Page _page;

  PagesPreviewWidgetState(this._page);

  Future<void> _updatePage(sdk.Page page) async {
    imageCache.clear();
    await _pageRepository.updatePage(page);
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Center(child: PageWidget(_page.documentImageFileUri)))),
        BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  _startCroppingScreen(_page);
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.crop),
                    Container(width: 4),
                    Text(
                      'Crop & Rotate',
                      style: TextStyle(inherit: true, color: Colors.black),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  _showFilterPage(_page);
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.filter),
                    Container(width: 4),
                    Text(
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
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete, color: Colors.red),
                    Container(width: 4),
                    Text(
                      'Delete',
                      style: TextStyle(inherit: true, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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

  Future<void> _rotatePage(sdk.Page page) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      final dialog = ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      dialog.style(message: 'Processing ...');
      dialog.show();
      final updatedPage = await ScanbotSdk.rotatePageClockwise(page, 1);
      await dialog.hide();
      if (updatedPage != null) {
        await _updatePage(updatedPage);
      }
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
        cancelButtonTitle: "Cancel",
        doneButtonTitle: "Save",
        // See further configs ...
      );
      final result = await ScanbotSdkUi.startCroppingScreen(page, config);
      if (isOperationSuccessful(result) && result.page != null) {
        await _updatePage(result.page);
      }
    } catch (e) {
      print(e);
    }
  }
}
