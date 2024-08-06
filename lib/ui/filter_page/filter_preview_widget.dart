import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;
import 'package:scanbot_sdk_example_flutter/utility/utils.dart';

import 'filter_button_widget.dart';

// ignore: must_be_immutable
class FilterPreviewWidget extends StatefulWidget {
  final sdk.Page page;
  late FilterPreviewWidgetState filterPreviewWidgetState;

  FilterPreviewWidget(this.page) {
    filterPreviewWidgetState = FilterPreviewWidgetState(page);
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
    final image = filteredImageUri != null
        ? FutureBuilder<Uint8List>(
            future: ScanbotEncryptionHandler.getDecryptedDataFromFile(
                filteredImageUri!),
            builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return Center(child: Image.memory(snapshot.data!));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )
        : Center(child: Text('No image available'));

    return ListView(
      padding: const EdgeInsets.all(10.0),
      shrinkWrap: true,
      children: <Widget>[
        buildImageContainer(image),
        buildFilterButton('None', () {
          applyParametricFilters(
              page, [LegacyFilter(filterType: ImageFilterType.NONE.index)]);
        }),
        buildFilterButton('Color Document Filter', () {
          applyParametricFilters(page, [ColorDocumentFilter()]);
        }),
        buildFilterButton('Scanbot Binarization Filter', () {
          applyParametricFilters(page, [ScanbotBinarizationFilter()]);
        }),
        buildFilterButton('Custom Binarization Filter', () {
          applyParametricFilters(page, [CustomBinarizationFilter()]);
        }),
        buildFilterButton('Brightness Filter', () {
          applyParametricFilters(page, [BrightnessFilter(brightness: 0.5)]);
        }),
        buildFilterButton('Contrast Filter', () {
          applyParametricFilters(page, [ContrastFilter(contrast: 125.0)]);
        }),
        buildFilterButton('Grayscale Filter', () {
          applyParametricFilters(page, [GrayscaleFilter()]);
        }),
        buildFilterButton('White Black Point Filter', () {
          applyParametricFilters(
              page, [WhiteBlackPointFilter(blackPoint: 0.5, whitePoint: 0.5)]);
        }),
        buildFilterButton('Legacy Low Light Binarization Filter', () {
          applyParametricFilters(page, [
            LegacyFilter(
                filterType: ImageFilterType.LOW_LIGHT_BINARIZATION.index)
          ]);
        }),
        buildFilterButton('Legacy Sensitive Binarization Filter', () {
          applyParametricFilters(page, [
            LegacyFilter(
                filterType: ImageFilterType.SENSITIVE_BINARIZATION.index)
          ]);
        }),
        buildFilterButton('Legacy Low Light Binarization Filter 2', () {
          applyParametricFilters(page, [
            LegacyFilter(
                filterType: ImageFilterType.LOW_LIGHT_BINARIZATION_2.index)
          ]);
        }),
        buildFilterButton('Legacy Edge Highlight Filter', () {
          applyParametricFilters(page,
              [LegacyFilter(filterType: ImageFilterType.EDGE_HIGHLIGHT.index)]);
        }),
        buildFilterButton('Legacy Deep Binarization Filter', () {
          applyParametricFilters(page, [
            LegacyFilter(
                filterType: ImageFilterType.LOW_LIGHT_BINARIZATION_2.index)
          ]);
        }),
        buildFilterButton('Legacy Otsu Binarization Filter', () {
          applyParametricFilters(page, [
            LegacyFilter(filterType: ImageFilterType.DEEP_BINARIZATION.index)
          ]);
        }),
        buildFilterButton('Legacy Clean Background Filter', () {
          applyParametricFilters(page, [
            LegacyFilter(filterType: ImageFilterType.OTSU_BINARIZATION.index)
          ]);
        }),
        buildFilterButton('Legacy Color Document Filter', () {
          applyParametricFilters(page,
              [LegacyFilter(filterType: ImageFilterType.COLOR_DOCUMENT.index)]);
        }),
        buildFilterButton('Legacy Color Filter', () {
          applyParametricFilters(
              page, [LegacyFilter(filterType: ImageFilterType.COLOR.index)]);
        }),
        buildFilterButton('Legacy Grayscale Filter', () {
          applyParametricFilters(page,
              [LegacyFilter(filterType: ImageFilterType.GRAYSCALE.index)]);
        }),
        buildFilterButton('Legacy Binarized Filter', () {
          applyParametricFilters(page,
              [LegacyFilter(filterType: ImageFilterType.BINARIZED.index)]);
        }),
        buildFilterButton('Legacy Pure Binarized Filter', () {
          applyParametricFilters(page,
              [LegacyFilter(filterType: ImageFilterType.PURE_BINARIZED.index)]);
        }),
        buildFilterButton('Legacy Black & White Filter', () {
          applyParametricFilters(page, [
            LegacyFilter(filterType: ImageFilterType.BLACK_AND_WHITE.index)
          ]);
        }),
      ],
    );
  }

  Widget buildFilterButton(String text, VoidCallback onPressed) {
    return FilterButton(text: text, onPressed: onPressed);
  }

  Container buildImageContainer(Widget image) {
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

  Future<void> applyParametricFilters(
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
