import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk_example_flutter/utility/utils.dart';
import 'filter_button_widget.dart';

class PageFiltering extends StatefulWidget {
  final sdk.Page initialPage;

  const PageFiltering(this.initialPage, {Key? key}) : super(key: key);

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

  void _updatePage(sdk.Page updatedPage) => setState(() => _page = updatedPage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScanbotAppBar('Filtering', context: context, showBackButton: true, onBack: () => Navigator.of(context).pop(_page)),
      body: FilterPreviewWidget(_page, _updatePage),
    );
  }
}

class FilterPreviewWidget extends StatefulWidget {
  final sdk.Page page;
  final ValueChanged<sdk.Page> onPageUpdated;

  const FilterPreviewWidget(this.page, this.onPageUpdated, {Key? key}) : super(key: key);

  @override
  State<FilterPreviewWidget> createState() => _FilterPreviewWidgetState();
}

class _FilterPreviewWidgetState extends State<FilterPreviewWidget> {
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
      sdk.Page page, List<ParametricFilter> filters) async {
    if (!await checkLicenseStatus(context)) return;
    try {
      final filteredPage = await ScanbotSdk.applyImageFilter(page, filters);
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
    return ListView(
      padding: const EdgeInsets.all(10.0),
      shrinkWrap: true,
      children: [
        buildImageContainer(),
        ..._buildFilterButtons(),
      ],
    );
  }

  Widget buildImageContainer() {
    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: filteredImageUri != null
          ? FutureBuilder<Uint8List>(
        future: ScanbotEncryptionHandler.getDecryptedDataFromFile(filteredImageUri!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Image.memory(snapshot.data!);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ) : const Center(child: Text('No image available')),
    );
  }

  List<Widget> _buildFilterButtons() {
    return [
      FilterButton(
        text: 'None',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.NONE.index)]),
      ),
      FilterButton(
        text: 'Color Document Filter',
        onPressed: () => applyParametricFilters(page, [ColorDocumentFilter()]),
      ),
      FilterButton(
        text: 'Scanbot Binarization Filter',
        onPressed: () => applyParametricFilters(page, [ScanbotBinarizationFilter()]),
      ),
      FilterButton(
        text: 'Custom Binarization Filter',
        onPressed: () => applyParametricFilters(page, [CustomBinarizationFilter(preset: BinarizationFilterPreset.PRESET_1)]),
      ),
      FilterButton(
        text: 'Brightness Filter',
        onPressed: () => applyParametricFilters(page, [BrightnessFilter(brightness: 0.5)]),
      ),
      FilterButton(
        text: 'Contrast Filter',
        onPressed: () => applyParametricFilters(page, [ContrastFilter(contrast: 125.0)]),
      ),
      FilterButton(
        text: 'Grayscale Filter',
        onPressed: () => applyParametricFilters(page, [GrayscaleFilter()]),
      ),
      FilterButton(
        text: 'White Black Point Filter',
        onPressed: () => applyParametricFilters(page, [WhiteBlackPointFilter(blackPoint: 0.5, whitePoint: 0.5)]),
      ),
      FilterButton(
        text: 'Legacy Color Filter',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.COLOR.typeIndex)]),
      ),
      FilterButton(
        text: 'Legacy Grayscale Filter',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.GRAYSCALE.typeIndex)]),
      ),
      FilterButton(
        text: 'Legacy Binarized Filter',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.BINARIZED.typeIndex)]),
      ),
      FilterButton(
        text: 'Legacy Color Document Filter',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.COLOR_DOCUMENT.typeIndex)]),
      ),
      FilterButton(
        text: 'Legacy Pure Binarized Filter',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.PURE_BINARIZED.typeIndex)]),
      ),
      FilterButton(
        text: 'Legacy Background Clean Filter',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.BACKGROUND_CLEAN.typeIndex)]),
      ),
      FilterButton(
        text: 'Legacy Black & White Filter',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.BLACK_AND_WHITE.typeIndex)]),
      ),
      FilterButton(
        text: 'Legacy Otsu Binarization Filter',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.OTSU_BINARIZATION.typeIndex)]),
      ),
      FilterButton(
        text: 'Legacy Deep Binarization Filter',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.DEEP_BINARIZATION.typeIndex)]),
      ),
      FilterButton(
        text: 'Legacy Edge Highlight Filter',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.EDGE_HIGHLIGHT.typeIndex)]),
      ),
      FilterButton(
        text: 'Legacy Low Light Binarization Filter',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.LOW_LIGHT_BINARIZATION.typeIndex)]),
      ),
      FilterButton(
        text: 'Legacy Low Light Binarization Filter 2',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.LOW_LIGHT_BINARIZATION_2.typeIndex)]),
      ),
      FilterButton(
        text: 'Legacy Sensitive Binarization Filter',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.SENSITIVE_BINARIZATION.typeIndex)]),
      ),
      FilterButton(
        text: 'Legacy Pure Gray Filter',
        onPressed: () => applyParametricFilters(page, [LegacyFilter(filterType: ImageFilterType.PURE_GRAY.typeIndex)]),
      ),
    ];
  }
}
