import 'package:scanbot_sdk_example_flutter/pages_repository.dart';
import 'package:scanbot_sdk_example_flutter/ui/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:scanbot_sdk/common_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk_example_flutter/ui/utils.dart';

class MultiPageFiltering extends StatelessWidget {
  PageRepository _pageRepository;

  MultiPageFiltering(this._pageRepository);

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    var filterPreviewWidget = MultiFilterPreviewWidget(_pageRepository);
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

class MultiFilterPreviewWidget extends StatefulWidget {
  MultiFilterPreviewWidgetState filterPreviewWidgetState;
  PageRepository _pageRepository;

  MultiFilterPreviewWidget(this._pageRepository) {
    filterPreviewWidgetState = MultiFilterPreviewWidgetState(_pageRepository);
  }

  applyFilter() {
    filterPreviewWidgetState.applyFilter();
  }

  @override
  State<MultiFilterPreviewWidget> createState() {
    return filterPreviewWidgetState;
  }
}

class MultiFilterPreviewWidgetState extends State<MultiFilterPreviewWidget> {
  ImageFilterType selectedFilter;
  PageRepository _pageRepository;

  MultiFilterPreviewWidgetState(this._pageRepository) {
    selectedFilter = ImageFilterType.NONE;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Select filter',
              style: TextStyle(
                  inherit: true,
                  color: Colors.black,
                  fontStyle: FontStyle.normal)),
        ),
        for (var filter in ImageFilterType.values)
          RadioListTile(
            title: titleFromFilterType(filter),
            value: filter,
            groupValue: selectedFilter,
            onChanged: (value) {
              changeSelectedFilter(value);
            },
          ),
      ],
    );
  }

  Text titleFromFilterType(ImageFilterType filterType) {
    return Text(filterType.toString().replaceAll("ImageFilterType.", ""),
        style: TextStyle(
            inherit: true, color: Colors.black, fontStyle: FontStyle.normal));
  }

  void changeSelectedFilter(ImageFilterType value) {
    setState(() {
      selectedFilter = value;
    });
  }

  applyFilter() {
    filterPages(selectedFilter);
  }

  filterPages(ImageFilterType filterType) async {
    if (!await checkLicenseStatus(context)) { return; }

    var dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: "Processing ...");
    dialog.show();
    var futures = _pageRepository.pages
        .map((page) => ScanbotSdk.applyImageFilter(page, filterType));

    try {
      var pages = await Future.wait(futures);
      pages.forEach((page) {
        _pageRepository.updatePage(page);
      });
    } catch (e) {
      print(e);
    }
    dialog.hide();
    Navigator.of(context).pop();
  }
}
