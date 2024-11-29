import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

import '../main.dart';
import '../utility/utils.dart';
import 'filter_page/filter_button_widget.dart';
import 'pages_widget.dart';

class PageOperations extends StatefulWidget {
  final PageData initialPage;
  final String documentID;

  PageOperations(this.documentID, this.initialPage);

  @override
  _PageOperationsState createState() => _PageOperationsState();
}

class _PageOperationsState extends State<PageOperations> {
  late PageData _page;
  bool showProgressBar = false;

  @override
  void initState() {
    super.initState();
    _page = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    // Determine which widget to display based on encryption requirement
    final imageUri = Uri(path: _page.documentImagePreviewURI?.replaceFirst('file://', ''));
    final pageView = shouldInitWithEncryption
        ? EncryptedPageWidget(imageUri)
        : PageWidget(imageUri);

    return Scaffold(
      appBar: ScanbotAppBar('Page Preview'),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: pageView),
                ),
              ),
            ],
          ),
          if (showProgressBar)
            const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  strokeWidth: 10,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: ScanbotRedColor,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildOptionButton(
              icon: Icons.crop,
              label: 'Crop',
              onPressed: () => _cropPage(),
            ),
            _buildOptionButton(
              icon: Icons.filter,
              label: 'Filter',
              onPressed: () => _settingModalFiltersSheet(),
            ),
            _buildOptionButton(
              icon: Icons.delete,
              label: 'Delete',
              onPressed: () => _deletePage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _settingModalFiltersSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            FilterButton(
                text: 'None',
                onPressed: () => applyParametricFilters([LegacyFilter(filterType: ImageFilterType.NONE.index)])),
            FilterButton(
                text: 'Color Document Filter',
                onPressed: () => applyParametricFilters([ColorDocumentFilter()])),
            FilterButton(
                text: 'Scanbot Binarization Filter',
                onPressed: () => applyParametricFilters([ScanbotBinarizationFilter()])),
            FilterButton(
                text: 'Custom Binarization Filter',
                onPressed: () => applyParametricFilters([CustomBinarizationFilter()])),
            FilterButton(
                text: 'Brightness Filter',
                onPressed: () {
                  applyParametricFilters([BrightnessFilter(brightness: 0.5)]);
                }),
            FilterButton(
                text: 'Contrast Filter',
                onPressed: () {
                  applyParametricFilters([ContrastFilter(contrast: 125.0)]);
                }),
            FilterButton(
                text: 'Grayscale Filter',
                onPressed: () {
                  applyParametricFilters([GrayscaleFilter()]);
                }),
            FilterButton(
                text: 'White Black Point Filter',
                onPressed: () {
                  applyParametricFilters([
                    WhiteBlackPointFilter(blackPoint: 0.5, whitePoint: 0.5)
                  ]);
                }),
          ],
        );
      },
    );
  }

  Future<void> _deletePage() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      await ScanbotSdk.Document.removePageFromDocument(RemovePageParams(documentID: widget.documentID, pageID:  _page.uuid));
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  Future<void> applyParametricFilters(List<ParametricFilter> list) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    try {
      var updatedDocument = await ScanbotSdk.Document.modifyPage(ModifyPageParams(documentID: widget.documentID, pageID: _page.uuid, filters: list));
      if(updatedDocument.value != null) {
        setState(() {
          _page = updatedDocument.value!.pages.firstWhere((x) => x.uuid == _page.uuid);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _cropPage() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    /** Create a new configuration with the document and the document's first page. */
    var configuration = CroppingConfiguration(
      documentUuid: widget.documentID,
      pageUuid: _page.uuid,
    );

    /* Customize the configuration. */
    configuration.cropping.bottomBar.rotateButton.visible = false;
    configuration.appearance.topBarBackgroundColor = ScanbotColor('#c8193c');
    configuration.cropping.topBarConfirmButton.foreground.color = ScanbotColor('#ffffff');
    configuration.localization.croppingTopBarCancelButtonTitle = 'Cancel';

    try {
      var result = await ScanbotSdkUiV2.startCroppingScreen(configuration);
      if (result.status == OperationStatus.OK &&
          result.value != null) {
        setState(() {
          _page = result.value!.pages.firstWhere((x) => x.uuid == _page.uuid);
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
