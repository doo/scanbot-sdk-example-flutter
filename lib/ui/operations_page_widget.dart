import 'package:scanbot_sdk_example_flutter/ui/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:scanbot_sdk/common_data.dart' as sdk;
import 'package:scanbot_sdk/cropping_screen_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
import 'package:scanbot_sdk_example_flutter/ui/utils.dart';

import '../main.dart';
import '../pages_repository.dart';
import 'filter_page_widget.dart';
import 'pages_widget.dart';

class PageOperations extends StatelessWidget {
  final sdk.Page _page;

  PageOperations(this._page);

  @override
  Widget build(BuildContext context) {
    imageCache?.clear();
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
    return new PagesPreviewWidgetState(_page);
  }
}

class PagesPreviewWidgetState extends State<PagesPreviewWidget> {
  final PageRepository _pageRepository = PageRepository();
  sdk.Page _page;

  PagesPreviewWidgetState(this._page);

  _updatePage(sdk.Page page) async {
    imageCache?.clear();
    await _pageRepository.updatePage(page);
    setState(() {
      this._page = page;
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
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Center(child: pageView))),
        BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.crop),
                    Container(width: 4),
                    Text('Crop & Rotate',
                        style: TextStyle(inherit: true, color: Colors.black)),
                  ],
                ),
                onPressed: () {
                  startCroppingScreen(_page);
                },
              ),
              TextButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.filter),
                    Container(width: 4),
                    Text('Filter',
                        style: TextStyle(inherit: true, color: Colors.black)),
                  ],
                ),
                onPressed: () {
                  showFilterPage(_page);
                },
              ),
              TextButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete, color: Colors.red),
                    Container(width: 4),
                    Text('Delete',
                        style: TextStyle(inherit: true, color: Colors.red)),
                  ],
                ),
                onPressed: () {
                  deletePage(_page);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  deletePage(sdk.Page page) async {
    try {
      ScanbotSdk.deletePage(page);
      await this._pageRepository.removePage(page);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  rotatePage(sdk.Page page) async {
    if (!await checkLicenseStatus(context)) { return; }

    try {
      var dialog = ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      dialog.style(message: "Processing ...");
      dialog.show();
      var updatedPage = await ScanbotSdk.rotatePageClockwise(page, 1);
      dialog.hide();
      await _updatePage(updatedPage);
    } catch (e) {
      print(e);
    }
  }

  showFilterPage(sdk.Page page) async {
    if (!await checkLicenseStatus(context)) { return; }

    var resultPage = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PageFiltering(page)),
    );
    if (resultPage != null) {
      await _updatePage(resultPage);
    }
  }

  startCroppingScreen(sdk.Page page) async {
    if (!await checkLicenseStatus(context)) { return; }

    try {
      var config = CroppingScreenConfiguration(
        bottomBarBackgroundColor: Colors.blue,
        // polygonColor: Colors.yellow,
        // polygonLineWidth: 10,
        cancelButtonTitle: "Cancel",
        doneButtonTitle: "Save",
        // See further configs ...
      );
      var result = await ScanbotSdkUi.startCroppingScreen(page, config);
      if (isOperationSuccessful(result) && result.page != null) {
        await _updatePage(result.page!);
      }
    } catch (e) {
      print(e);
    }
  }
}
