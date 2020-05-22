import 'dart:io';

import 'package:scanbot_sdk_example_flutter/ui/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:scanbot_sdk/common_data.dart' as c;
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk_example_flutter/ui/utils.dart';

class PageFiltering extends StatelessWidget {
  c.Page _page;

  PageFiltering(this._page);

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    var filterPreviewWidget = FilterPreviewWidget(_page);
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                filterPreviewWidget.applyFilter();
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text('APPLY',
                      style: TextStyle(inherit: true, color: Colors.black)),
                ),
              ),
            ),
          ],
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: const Text('Filtering',
              style: TextStyle(inherit: true, color: Colors.black)),
        ),
        body: filterPreviewWidget);
  }
}

class FilterPreviewWidget extends StatefulWidget {
  c.Page page;
  FilterPreviewWidgetState filterPreviewWidgetState;

  FilterPreviewWidget(this.page) {
    filterPreviewWidgetState = new FilterPreviewWidgetState(page);
  }

  applyFilter() {
    filterPreviewWidgetState.applyFilter();
  }

  @override
  State<FilterPreviewWidget> createState() {
    return filterPreviewWidgetState;
  }
}

class FilterPreviewWidgetState extends State<FilterPreviewWidget> {
  c.Page page;
  Uri filteredImageUri;
  c.ImageFilterType selectedFilter;

  FilterPreviewWidgetState(this.page) {
    filteredImageUri = page.documentImageFileUri;
    selectedFilter = page.filter ?? c.ImageFilterType.NONE;
  }

  @override
  Widget build(BuildContext context) {
    var file = File.fromUri(filteredImageUri);
    var image = Image.file(
      file,
      height: double.infinity,
      width: double.infinity,
    );
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        buildContainer(image),
        Text('Select filter',
            style: TextStyle(
                inherit: true,
                color: Colors.black,
                fontStyle: FontStyle.normal)),
        for (var filter in c.ImageFilterType.values)
          RadioListTile(
            title: titleFromFilterType(filter),
            value: filter,
            groupValue: selectedFilter,
            onChanged: (value) {
              previewFilter(page, value);
            },
          ),
      ],
    );
  }

  Container buildContainer(Widget image) {
    return Container(
        height: 400,
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Center(
            child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(child: image),
        )));
  }

  Text titleFromFilterType(c.ImageFilterType filterType) {
    return Text(filterType.toString().replaceAll("ImageFilterType.", ""),
        style: TextStyle(
            inherit: true, color: Colors.black, fontStyle: FontStyle.normal));
  }

  applyFilter() async {
    if (!await checkLicenseStatus(context)) { return; }

    var dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: "Processing");
    dialog.show();
    try {
      var updatedPage = await ScanbotSdk.applyImageFilter(page, selectedFilter);
      dialog.hide();
      Navigator.of(context).pop(updatedPage);
    } catch (e) {
      dialog.hide();
      print(e);
    }
  }

  previewFilter(c.Page page, c.ImageFilterType filterType) async {
    if (!await checkLicenseStatus(context)) { return; }

    try {
      var uri = await ScanbotSdk.getFilteredDocumentPreviewUri(page, filterType);
      setState(() {
        selectedFilter = filterType;
        filteredImageUri = uri;
      });
    } catch (e) {
      print(e);
    }
  }
}
