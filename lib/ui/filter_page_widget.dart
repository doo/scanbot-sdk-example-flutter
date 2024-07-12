import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;
import 'package:scanbot_sdk_example_flutter/utility/utils.dart';

class PageFiltering extends StatelessWidget {
  final sdk.Page _page;

  PageFiltering(this._page);

  @override
  Widget build(BuildContext context) {
    var filterPreviewWidget = FilterPreviewWidget(_page);
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
                  child: Text('Back',
                      style: TextStyle(inherit: true, color: Colors.black)),
                ),
              ),
            ),
          ],
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: const Text('Filtering',
              style: TextStyle(inherit: true, color: Colors.black)),
        ),
        body: filterPreviewWidget);
  }
}

// ignore: must_be_immutable
class FilterPreviewWidget extends StatefulWidget {
  final sdk.Page page;
  late FilterPreviewWidgetState filterPreviewWidgetState;

  FilterPreviewWidget(this.page) {
    filterPreviewWidgetState = FilterPreviewWidgetState(page);
  }

  void applyFilter() {
    filterPreviewWidgetState.navigateBack();
  }

  @override
  State<FilterPreviewWidget> createState() {
    return filterPreviewWidgetState;
  }
}

class FilterPreviewWidgetState extends State<FilterPreviewWidget> {
  sdk.Page page;
  Uri? filteredImageUri;
  late ImageFilterType selectedFilter;

  FilterPreviewWidgetState(this.page) {
    filteredImageUri = page.documentImageFileUri;
    selectedFilter = page.filter ?? ImageFilterType.NONE;
  }

  @override
  Widget build(BuildContext context) {
    final imageData =
        ScanbotEncryptionHandler.getDecryptedDataFromFile(filteredImageUri!);
    final image = FutureBuilder<Uint8List>(
        future: imageData,
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.data != null) {
            var image = Image.memory(snapshot.data!);
            return Center(child: image);
          } else {
            return Container();
          }
        });
    return ListView(
      padding: const EdgeInsets.all(10.0),
      shrinkWrap: true,
      children: <Widget>[
        buildContainer(image),
        buildFilterButton('Scanbot Binarization Filter', () {
          previewParametricFilters(page, [ScanbotBinarizationFilter()]);
        }),
        buildFilterButton('Custom Binarization Filter', () {
          previewParametricFilters(page, [CustomBinarizationFilter()]);
        }),
        buildFilterButton('Brightness Filter', () {
          previewParametricFilters(page, [BrightnessFilter()]);
        }),
        buildFilterButton('Contrast Filter', () {
          previewParametricFilters(page, [ContrastFilter()]);
        }),
        buildFilterButton('Grayscale Filter', () {
          previewParametricFilters(page, [GrayscaleFilter()]);
        }),
        buildFilterButton('White Black Point Filter', () {
          previewParametricFilters(page, [WhiteBlackPointFilter()]);
        }),
        buildFilterButton('Legacy Low Light Binarization Filter', () {
          previewParametricFilters(page, [
            LegacyFilter(
                filterType: ImageFilterType.LOW_LIGHT_BINARIZATION.index)
          ]);
        }),
        buildFilterButton('Legacy Sensitive Binarization Filter', () {
          previewParametricFilters(page, [
            LegacyFilter(
                filterType: ImageFilterType.SENSITIVE_BINARIZATION.index)
          ]);
        }),
        buildFilterButton('Legacy Low Light Binarization Filter 2', () {
          previewParametricFilters(page, [
            LegacyFilter(
                filterType: ImageFilterType.LOW_LIGHT_BINARIZATION_2.index)
          ]);
        }),
        buildFilterButton('Legacy Edge Highlight Filter', () {
          previewParametricFilters(page,
              [LegacyFilter(filterType: ImageFilterType.EDGE_HIGHLIGHT.index)]);
        }),
        buildFilterButton('Legacy Deep Binarization Filter', () {
          previewParametricFilters(page, [
            LegacyFilter(
                filterType: ImageFilterType.LOW_LIGHT_BINARIZATION_2.index)
          ]);
        }),
        buildFilterButton('Legacy Otsu Binarization Filter', () {
          previewParametricFilters(page, [
            LegacyFilter(filterType: ImageFilterType.DEEP_BINARIZATION.index)
          ]);
        }),
        buildFilterButton('Legacy Clean Background Filter', () {
          previewParametricFilters(page, [
            LegacyFilter(filterType: ImageFilterType.OTSU_BINARIZATION.index)
          ]);
        }),
        buildFilterButton('Legacy Color Document Filter', () {
          previewParametricFilters(page,
              [LegacyFilter(filterType: ImageFilterType.COLOR_DOCUMENT.index)]);
        }),
        buildFilterButton('Legacy Color Filter', () {
          previewParametricFilters(
              page, [LegacyFilter(filterType: ImageFilterType.COLOR.index)]);
        }),
        buildFilterButton('Legacy Grayscale Filter', () {
          previewParametricFilters(page,
              [LegacyFilter(filterType: ImageFilterType.GRAYSCALE.index)]);
        }),
        buildFilterButton('Legacy Binarized Filter', () {
          previewParametricFilters(page,
              [LegacyFilter(filterType: ImageFilterType.BINARIZED.index)]);
        }),
        buildFilterButton('Legacy Pure Binarized Filter', () {
          previewParametricFilters(page,
              [LegacyFilter(filterType: ImageFilterType.PURE_BINARIZED.index)]);
        }),
        buildFilterButton('Legacy Black & White Filter', () {
          previewParametricFilters(page, [
            LegacyFilter(filterType: ImageFilterType.BLACK_AND_WHITE.index)
          ]);
        }),
      ],
    );
  }

  Widget buildFilterButton(String text, VoidCallback onPressed) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20.0),
            backgroundColor: Colors.grey[800], // Dark gray background
            foregroundColor: Colors.white, // White text
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(0), // Straight quadratish shape
            ),
            textStyle: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(text),
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }

  Container buildContainer(Widget image) {
    return Container(
      height: 400,
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Center(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Center(child: image),
        ),
      ),
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

  Future<void> navigateBack() async {
    Navigator.of(context).pop(page);
  }

  Future<void> previewParametricFilters(
      sdk.Page page, List<ParametricFilter> parametricFilters) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      var filteredPage =
          await ScanbotSdk.applyImageFilter(page, parametricFilters);

      setState(() {
        page = filteredPage;
        filteredImageUri = page.documentPreviewImageFileUri;
      });
    } catch (e) {
      print(e);
    }
  }
}
