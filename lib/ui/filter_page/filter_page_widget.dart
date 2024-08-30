import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk_example_flutter/utility/utils.dart';
import 'filter_button_widget.dart';

class PageFiltering extends StatefulWidget {
  final sdk.Page initialPage;

  PageFiltering(this.initialPage);

  @override
  State<PageFiltering> createState() => _PageFilteringState();
}

class _PageFilteringState extends State<PageFiltering> {
  late sdk.Page _page;

  @override
  void initState() {
    super.initState();
    _page = widget.initialPage;
  }

  void _updatePage(sdk.Page updatedPage) {
    setState(() {
      _page = updatedPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(_page),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Filtering',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FilterPreviewWidget(
        _page,
        _updatePage,
      ),
    );
  }
}

class FilterPreviewWidget extends StatefulWidget {
  final sdk.Page page;
  final Function(sdk.Page) onPageUpdated;

  FilterPreviewWidget(this.page, this.onPageUpdated);

  @override
  State<FilterPreviewWidget> createState() => FilterPreviewWidgetState();
}

class FilterPreviewWidgetState extends State<FilterPreviewWidget> {
  late sdk.Page page;
  Uri? filteredImageUri;
  late ImageFilterType selectedFilter;

  @override
  void initState() {
    super.initState();
    page = widget.page;
    filteredImageUri = page.documentImageFileUri;
    selectedFilter = page.filter ?? ImageFilterType.NONE;
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
        this.page = filteredPage;
        filteredImageUri = page.documentImageFileUri;
        widget.onPageUpdated(filteredPage);
      });
    } catch (e) {
      print(e);
    }
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
        : const Center(child: Text('No image available'));

    return ListView(
      padding: const EdgeInsets.all(10.0),
      shrinkWrap: true,
      children: <Widget>[
        buildImageContainer(image),
        FilterButton(
            text: 'None',
            onPressed: () {
              applyParametricFilters(
                  page, [LegacyFilter(filterType: ImageFilterType.NONE.index)]);
            }),
        FilterButton(
            text: 'Color Document Filter',
            onPressed: () {
              applyParametricFilters(page, [ColorDocumentFilter()]);
            }),
        FilterButton(
            text: 'Scanbot Binarization Filter',
            onPressed: () {
              applyParametricFilters(page, [ScanbotBinarizationFilter()]);
            }),
        FilterButton(
            text: 'Custom Binarization Filter',
            onPressed: () {
              applyParametricFilters(page, [CustomBinarizationFilter()]);
            }),
        FilterButton(
            text: 'Brightness Filter',
            onPressed: () {
              applyParametricFilters(page, [BrightnessFilter(brightness: 0.5)]);
            }),
        FilterButton(
            text: 'Contrast Filter',
            onPressed: () {
              applyParametricFilters(page, [ContrastFilter(contrast: 125.0)]);
            }),
        FilterButton(
            text: 'Grayscale Filter',
            onPressed: () {
              applyParametricFilters(page, [GrayscaleFilter()]);
            }),
        FilterButton(
            text: 'White Black Point Filter',
            onPressed: () {
              applyParametricFilters(page,
                  [WhiteBlackPointFilter(blackPoint: 0.5, whitePoint: 0.5)]);
            }),
        FilterButton(
            text: 'Legacy Color Filter',
            onPressed: () {
              applyParametricFilters(page,
                  [LegacyFilter(filterType: ImageFilterType.COLOR.typeIndex)]);
            }),
        FilterButton(
            text: 'Legacy Grayscale Filter',
            onPressed: () {
              applyParametricFilters(page, [
                LegacyFilter(filterType: ImageFilterType.GRAYSCALE.typeIndex)
              ]);
            }),
        FilterButton(
            text: 'Legacy Binarized Filter',
            onPressed: () {
              applyParametricFilters(page, [
                LegacyFilter(filterType: ImageFilterType.BINARIZED.typeIndex)
              ]);
            }),
        FilterButton(
            text: 'Legacy Color Document Filter',
            onPressed: () {
              applyParametricFilters(page, [
                LegacyFilter(
                    filterType: ImageFilterType.COLOR_DOCUMENT.typeIndex)
              ]);
            }),
        FilterButton(
            text: 'Legacy Pure Binarized Filter',
            onPressed: () {
              applyParametricFilters(page, [
                LegacyFilter(
                    filterType: ImageFilterType.PURE_BINARIZED.typeIndex)
              ]);
            }),
        FilterButton(
            text: 'Legacy Background Clean Filter',
            onPressed: () {
              applyParametricFilters(page, [
                LegacyFilter(
                    filterType: ImageFilterType.BACKGROUND_CLEAN.typeIndex)
              ]);
            }),
        FilterButton(
            text: 'Legacy Black & White Filter',
            onPressed: () {
              applyParametricFilters(page, [
                LegacyFilter(
                    filterType: ImageFilterType.BLACK_AND_WHITE.typeIndex)
              ]);
            }),
        FilterButton(
            text: 'Legacy Otsu Binarization Filter',
            onPressed: () {
              applyParametricFilters(page, [
                LegacyFilter(
                    filterType: ImageFilterType.OTSU_BINARIZATION.typeIndex)
              ]);
            }),
        FilterButton(
            text: 'Legacy Deep Binarization Filter',
            onPressed: () {
              applyParametricFilters(page, [
                LegacyFilter(
                    filterType: ImageFilterType.DEEP_BINARIZATION.typeIndex)
              ]);
            }),
        FilterButton(
            text: 'Legacy Edge Highlight Filter',
            onPressed: () {
              applyParametricFilters(page, [
                LegacyFilter(
                    filterType: ImageFilterType.EDGE_HIGHLIGHT.typeIndex)
              ]);
            }),
        FilterButton(
            text: 'Legacy Low Light Binarization Filter',
            onPressed: () {
              applyParametricFilters(page, [
                LegacyFilter(
                    filterType:
                        ImageFilterType.LOW_LIGHT_BINARIZATION.typeIndex)
              ]);
            }),
        FilterButton(
            text: 'Legacy Low Light Binarization Filter 2',
            onPressed: () {
              applyParametricFilters(page, [
                LegacyFilter(
                    filterType:
                        ImageFilterType.LOW_LIGHT_BINARIZATION_2.typeIndex)
              ]);
            }),
        FilterButton(
            text: 'Legacy Sensitive Binarization Filter',
            onPressed: () {
              applyParametricFilters(page, [
                LegacyFilter(
                    filterType:
                        ImageFilterType.SENSITIVE_BINARIZATION.typeIndex)
              ]);
            }),
        FilterButton(
            text: 'Legacy Pure Gray Filter',
            onPressed: () {
              applyParametricFilters(page, [
                LegacyFilter(filterType: ImageFilterType.PURE_GRAY.typeIndex)
              ]);
            }),
      ],
    );
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
}
