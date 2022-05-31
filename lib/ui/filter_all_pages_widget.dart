import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/common_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk_example_flutter/pages_repository.dart';
import 'package:scanbot_sdk_example_flutter/ui/progress_dialog.dart';
import 'package:scanbot_sdk_example_flutter/ui/utils.dart';

class MultiPageFiltering extends StatelessWidget {
  final PageRepository _pageRepository;

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
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'APPLY',
                    style: TextStyle(
                      inherit: true,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Filtering',
            style: TextStyle(
              inherit: true,
              color: Colors.black,
            ),
          ),
        ),
        body: filterPreviewWidget);
  }
}

// ignore: must_be_immutable
class MultiFilterPreviewWidget extends StatefulWidget {
  late MultiFilterPreviewWidgetState filterPreviewWidgetState;
  final PageRepository _pageRepository;

  MultiFilterPreviewWidget(this._pageRepository) {
    filterPreviewWidgetState = MultiFilterPreviewWidgetState(_pageRepository);
  }

  void applyFilter() {
    filterPreviewWidgetState.applyFilter();
  }

  @override
  State<MultiFilterPreviewWidget> createState() {
    return filterPreviewWidgetState;
  }
}

class MultiFilterPreviewWidgetState extends State<MultiFilterPreviewWidget> {
  late ImageFilterType selectedFilter;
  final PageRepository _pageRepository;

  MultiFilterPreviewWidgetState(this._pageRepository) {
    selectedFilter = ImageFilterType.NONE;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(16.0),
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
              changeSelectedFilter(
                  (value as ImageFilterType?) ?? ImageFilterType.NONE);
            },
          ),
      ],
    );
  }

  Text titleFromFilterType(ImageFilterType filterType) {
    return Text(
      filterType.toString().replaceAll('ImageFilterType.', ''),
      style: const TextStyle(
        inherit: true,
        color: Colors.black,
        fontStyle: FontStyle.normal,
      ),
    );
  }

  void changeSelectedFilter(ImageFilterType value) {
    setState(() {
      selectedFilter = value;
    });
  }

  void applyFilter() {
    filterPages(selectedFilter);
  }

  Future<void> filterPages(ImageFilterType filterType) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    final dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: 'Processing ...');
    dialog.show();
    final futures = _pageRepository.pages
        .map((page) => ScanbotSdk.applyImageFilter(page, filterType));

    try {
      final pages = await Future.wait(futures);
      for (var page in pages) {
        _pageRepository.updatePage(page);
      }
    } catch (e) {
      print(e);
    }
    await dialog.hide();
    Navigator.of(context).pop();
  }
}
