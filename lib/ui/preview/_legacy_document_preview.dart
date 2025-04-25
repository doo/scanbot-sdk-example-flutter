import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanbot_sdk/core.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

import 'package:scanbot_sdk_example_flutter/ui/progress_dialog.dart';
import 'package:scanbot_sdk_example_flutter/utility/utils.dart';

import '../../storage/_legacy_pages_repository.dart';
import '../filter_page/filter_button_widget.dart';
import '../_legacy_operations_page_widget.dart';
import '../pages_widget.dart';

class LegacyDocumentPreview extends StatefulWidget {
  @override
  _LegacyDocumentPreviewState createState() => _LegacyDocumentPreviewState();
}

class _LegacyDocumentPreviewState extends State<LegacyDocumentPreview> {
  final LegacyPageRepository _pageRepository = LegacyPageRepository();
  late List<sdk.Page> _pages;

  @override
  void initState() {
    _pages = _pageRepository.pages;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScanbotAppBar('Image results', showBackButton: true, context: context),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                ),
                itemBuilder: (context, position) {
                  final imageUri =
                  _pages[position].documentPreviewImageFileUri!;
                  final pageView = shouldInitWithEncryption
                      ? EncryptedPageWidget(imageUri)
                      : PageWidget(imageUri);

                  return GridTile(
                    child: GestureDetector(
                      onTap: () => _showOperationsPage(_pages[position]),
                      child: pageView,
                    ),
                  );
                },
                itemCount: _pages.length,
              ),
            ),
          ),
          BottomAppBar(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildButton(
                  icon: Icons.add_circle,
                  label: 'Add',
                  onPressed: () => _addPageModalBottomSheet(context),
                ),
                _buildButton(
                  icon: Icons.more_vert,
                  label: 'More',
                  onPressed: () => _settingModalBottomSheet(context),
                ),
                _buildButton(
                  icon: Icons.delete,
                  label: 'Delete All',
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onPressed: () => _showCleanupStorageDialog(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Helper method to build a button with an icon and text
  Widget _buildButton({
    required IconData icon,
    required String label,
    Color iconColor = Colors.black,
    Color textColor = Colors.black,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: <Widget>[
          Icon(icon, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }

  Future<void> _showOperationsPage(sdk.Page page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => LegacyPageOperations(page)),
    );
    _updatePagesList();
  }

  void _settingModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Perform OCR'),
              onTap: () {
                Navigator.pop(context);
                _performOcr();
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Save as PDF'),
              onTap: () {
                Navigator.pop(context);
                _createPdf();
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Save as PDF with OCR'),
              onTap: () {
                Navigator.pop(context);
                _createPdfWithOcr();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Save as TIFF with ScanbotBinarization'),
              onTap: () {
                Navigator.pop(context);
                _createTiffWithScanbotBinarization();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Save as TIFF with LegacyBinarization'),
              onTap: () {
                Navigator.pop(context);
                _createTiffWithLegacyBinarization();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Save as TIFF'),
              onTap: () {
                Navigator.pop(context);
                _createTiffWithoutBinarization();
              },
            ),
            ListTile(
              leading: const Icon(Icons.filter),
              title: const Text('Apply filter for all pages'),
              onTap: () {
                Navigator.pop(context);
                _settingModalFiltersSheet(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _settingModalFiltersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          padding: const EdgeInsets.all(10.0),
          shrinkWrap: true,
          children: <Widget>[
            FilterButton(
                text: 'None',
                onPressed: () => applyParametricFilters(_pages, [LegacyFilter(filterType: ImageFilterType.NONE.index)])),
            FilterButton(
                text: 'Color Document Filter',
                onPressed: () => applyParametricFilters(_pages, [ColorDocumentFilter()])),
            FilterButton(
                text: 'Scanbot Binarization Filter',
                onPressed: () => applyParametricFilters(_pages, [ScanbotBinarizationFilter()])),
            FilterButton(
                text: 'Custom Binarization Filter',
                onPressed: () => applyParametricFilters(_pages, [CustomBinarizationFilter()])),
            FilterButton(
                text: 'Brightness Filter',
                onPressed: () {
                  applyParametricFilters(
                      _pages, [BrightnessFilter(brightness: 0.5)]);
                }),
            FilterButton(
                text: 'Contrast Filter',
                onPressed: () {
                  applyParametricFilters(
                      _pages, [ContrastFilter(contrast: 125.0)]);
                }),
            FilterButton(
                text: 'Grayscale Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [GrayscaleFilter()]);
                }),
            FilterButton(
                text: 'White Black Point Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    WhiteBlackPointFilter(blackPoint: 0.5, whitePoint: 0.5)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Color Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(filterType: ImageFilterType.COLOR.typeIndex)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Grayscale Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(
                        filterType: ImageFilterType.GRAYSCALE.typeIndex)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Binarized Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(
                        filterType: ImageFilterType.BINARIZED.typeIndex)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Color Document Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(
                        filterType: ImageFilterType.COLOR_DOCUMENT.typeIndex)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Pure Binarized Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(
                        filterType: ImageFilterType.PURE_BINARIZED.typeIndex)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Background Clean Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(
                        filterType: ImageFilterType.BACKGROUND_CLEAN.typeIndex)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Black & White Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(
                        filterType: ImageFilterType.BLACK_AND_WHITE.typeIndex)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Otsu Binarization Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(
                        filterType: ImageFilterType.OTSU_BINARIZATION.typeIndex)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Deep Binarization Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(
                        filterType: ImageFilterType.DEEP_BINARIZATION.typeIndex)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Edge Highlight Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(
                        filterType: ImageFilterType.EDGE_HIGHLIGHT.typeIndex)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Low Light Binarization Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(
                        filterType:
                        ImageFilterType.LOW_LIGHT_BINARIZATION.typeIndex)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Low Light Binarization Filter 2',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(
                        filterType:
                        ImageFilterType.LOW_LIGHT_BINARIZATION_2.typeIndex)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Sensitive Binarization Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(
                        filterType:
                        ImageFilterType.SENSITIVE_BINARIZATION.typeIndex)
                  ]);
                }),
            FilterButton(
                text: 'Legacy Pure Gray Filter',
                onPressed: () {
                  applyParametricFilters(_pages, [
                    LegacyFilter(
                        filterType: ImageFilterType.PURE_GRAY.typeIndex)
                  ]);
                }),
          ],
        );
      },
    );
  }

  // Shows a modal bottom sheet for adding pages.
  void _addPageModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.scanner),
              title: const Text('Scan Page'),
              onTap: () {
                Navigator.pop(context);
                _startDocumentScanning();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_size_select_actual),
              title: const Text('Import Page'),
              onTap: () {
                Navigator.pop(context);
                _importImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Applies a list of parametric filters to a list of pages.
  Future<void> applyParametricFilters(
      List<sdk.Page> pages, List<ParametricFilter> parametricFilters) async {
    if (!await checkLicenseStatus(context)) return;

    try {
        for (final page in pages) {
          final filteredPage = await ScanbotSdk.applyImageFilter(page, parametricFilters);
          await _pageRepository.updatePage(filteredPage);
        }
      _updatePagesList();
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  // Starts document scanning and adds the pages to the repository.
  Future<void> _startDocumentScanning() async {
    if (!await checkLicenseStatus(context)) return;

    try {
      final config = DocumentScannerConfiguration(
        orientationLockMode: OrientationLockMode.PORTRAIT,
        cameraPreviewMode: CameraPreviewMode.FIT_IN,
        multiPageEnabled: false,
        multiPageButtonHidden: true,
      );
      final result = await ScanbotSdkUi.startDocumentScanner(config);

      if (isOperationSuccessful(result)) {
        await _pageRepository.addPages(result.pages);
        _updatePagesList();
      }
    } catch (e) {
      print(e);
    }
  }

  // Shows a dialog for confirming storage cleanup.
  void _showCleanupStorageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete all'),
          content: const Text('Delete all images and generated files (PDF, TIFF, etc)?'),
          contentPadding: const EdgeInsets.all(16.0),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _cleanupStorage();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cleanupStorage() async {
    try {
      await ScanbotSdk.cleanupStorage();
      await _pageRepository.clearPages();
      _updatePagesList();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _createPdf() async {
    if (!await _checkHasPages(context)) {
      return;
    }
    if (!await checkLicenseStatus(context)) {
      return;
    }

    final dialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: 'Creating PDF ...');
    try {
      dialog.show();
      var options = const PdfRenderingOptions(pageSize: PageSize.A4);
      final pdfFileUri =
      await ScanbotSdk.createPdf(_pageRepository.pages, options);
      await dialog.hide();
      await showAlertDialog(context, pdfFileUri.toString(),
          title: 'PDF file URI');
    } catch (e) {
      print(e);
      await dialog.hide();
    }
  }

  Future<void> _importImage() async {
    try {
      final XFile? image = await selectImageFromLibrary();
      if (image?.path != null) {
        await _createPage(Uri.file(image!.path));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _createPage(Uri uri) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    var dialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: true);
    dialog.style(message: 'Processing ...');
    dialog.show();
    try {
      var page = await ScanbotSdk.createPage(uri, false);
      page = await ScanbotSdk.detectDocument(page);
      await dialog.hide();
      await _pageRepository.addPage(page);
      _updatePagesList();
    } catch (e) {
      print(e);
      await dialog.hide();
    }
  }

  Future<void> _createTiff(TiffCreationOptions Function() optionsProvider) async {
    if (!await _checkHasPages(context)) {
      return;
    }
    if (!await checkLicenseStatus(context)) {
      return;
    }

    final dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: 'Creating TIFF ...');
    dialog.show();

    try {
      var options = optionsProvider();
      final tiffFileUri =
      await ScanbotSdk.createTiff(_pageRepository.pages, options);
      await dialog.hide();
      await showAlertDialog(context, tiffFileUri.toString(),
          title: 'TIFF file URI');
    } catch (e) {
      print(e);
    } finally {
      await dialog.hide();
    }
  }

  Future<void> _createTiffWithScanbotBinarization() async {
    await _createTiff(() => TiffCreationOptions.withScanbotBinarizationFilter(
        ScanbotBinarizationFilter(),
        dpi: 200,
        compression: TiffCompression.CCITT_T4));
  }

  Future<void> _createTiffWithLegacyBinarization() async {
    await _createTiff(() => TiffCreationOptions.withLegacyImageFilterType(
        LegacyBinarizationFilter.BINARIZED,
        dpi: 200,
        compression: TiffCompression.CCITT_T4));
  }

  Future<void> _createTiffWithoutBinarization() async {
    await _createTiff(
            () => TiffCreationOptions(dpi: 200, compression: TiffCompression.LZW));
  }

  Future<void> _performOcr() async {
    if (!await _checkHasPages(context)) {
      return;
    }
    if (!await checkLicenseStatus(context)) {
      return;
    }

    final dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: 'Performing OCR ...');
    dialog.show();
    try {
      final result = await ScanbotSdk.performOcr(
          _pages, OcrOptions(languages: ['en', 'de']));
      await dialog.hide();
      await showAlertDialog(
          context, 'Plain text:\n' + (result.plainText ?? ''));
    } catch (e) {
      print(e);
      await dialog.hide();
    }
  }

  Future<void> _createPdfWithOcr() async {
    if (!await _checkHasPages(context)) {
      return;
    }
    if (!await checkLicenseStatus(context)) {
      return;
    }

    var dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: 'Performing OCR with PDF ...');
    dialog.show();
    try {
      var pdfFileUri = await ScanbotSdk.createPdf(
          _pages, PdfRenderingOptions(ocrConfiguration: OcrOptions(engineMode: OcrEngine.SCANBOT_OCR)));
      await showAlertDialog(context, pdfFileUri.toString(),
          title: 'PDF file URI');
      await dialog.hide();
    } catch (e) {
      print(e);
      await dialog.hide();
    }
  }

  Future<bool> _checkHasPages(BuildContext context) async {
    if (_pages.isNotEmpty) {
      return true;
    }
    await showAlertDialog(context,
        'Please scan or import some documents to perform this function.',
        title: 'Info');
    return false;
  }

  Future<void> _updatePagesList() async {
    setState(() {
      _pages = _pageRepository.pages;
    });
  }
}