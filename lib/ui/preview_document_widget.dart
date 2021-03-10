import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanbot_sdk/common_data.dart' as sdk;
import 'package:scanbot_sdk/create_tiff_data.dart';
import 'package:scanbot_sdk/document_scan_data.dart';
import 'package:scanbot_sdk/ocr_data.dart';
import 'package:scanbot_sdk/render_pdf_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
import 'package:scanbot_sdk_example_flutter/ui/progress_dialog.dart';
import 'package:scanbot_sdk_example_flutter/ui/utils.dart';

import '../main.dart';
import '../pages_repository.dart';
import 'filter_all_pages_widget.dart';
import 'operations_page_widget.dart';
import 'pages_widget.dart';

class DocumentPreview extends StatefulWidget {
  @override
  _DocumentPreviewState createState() => _DocumentPreviewState();
}

class _DocumentPreviewState extends State<DocumentPreview> {
  final PageRepository _pageRepository = PageRepository();
  List<sdk.Page> _pages;

  @override
  void initState() {
    _pages = _pageRepository.pages;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Image results',
          style: TextStyle(
            inherit: true,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200),
                  itemBuilder: (context, position) {
                    Widget pageView;
                    if (shouldInitWithEncryption) {
                      pageView = EncryptedPageWidget(
                          _pages[position].documentPreviewImageFileUri);
                    } else {
                      pageView = PageWidget(
                          _pages[position].documentPreviewImageFileUri);
                    }
                    return GridTile(
                      child: GestureDetector(
                          onTap: () {
                            _showOperationsPage(_pages[position]);
                          },
                          child: pageView),
                    );
                  },
                  itemCount: _pages?.length ?? 0),
            ),
          ),
          BottomAppBar(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    _addPageModalBottomSheet(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_circle),
                      Container(width: 4),
                      Text(
                        'Add',
                        style: TextStyle(
                          inherit: true,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _settingModalBottomSheet(context);
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.more_vert),
                      Container(width: 4),
                      Text(
                        'More',
                        style: TextStyle(
                          inherit: true,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showCleanupStorageDialog();
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      Container(width: 4),
                      Text(
                        'Delete All',
                        style: TextStyle(
                          inherit: true,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showOperationsPage(sdk.Page page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PageOperations(page)),
    );
    _updatePagesList();
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.text_fields),
                  title: Text('Perform OCR'),
                  onTap: () {
                    Navigator.pop(context);
                    _performOcr();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.picture_as_pdf),
                  title: Text('Save as PDF'),
                  onTap: () {
                    Navigator.pop(context);
                    _createPdf();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.picture_as_pdf),
                  title: Text('Save as PDF with OCR'),
                  onTap: () {
                    Navigator.pop(context);
                    _createOcrPdf();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Safe as TIFF'),
                  onTap: () {
                    Navigator.pop(context);
                    _createTiff(false);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Save as TIFF 1-bit encoded'),
                  onTap: () {
                    Navigator.pop(context);
                    _createTiff(true);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Apply Image Filter on ALL pages'),
                  onTap: () {
                    Navigator.pop(context);
                    _filterAllPages();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.close),
                  title: Text('Cancel'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }

  void _addPageModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.scanner),
                  title: Text('Scan Page'),
                  onTap: () {
                    Navigator.pop(context);
                    _startDocumentScanning();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_size_select_actual),
                  title: Text('Import Page'),
                  onTap: () {
                    Navigator.pop(context);
                    _importImage();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.close),
                  title: Text('Cancel'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _startDocumentScanning() async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    DocumentScanningResult result;
    try {
      var config = DocumentScannerConfiguration(
        orientationLockMode: sdk.CameraOrientationMode.PORTRAIT,
        cameraPreviewMode: sdk.CameraPreviewMode.FIT_IN,
        ignoreBadAspectRatio: true,
        multiPageEnabled: false,
        multiPageButtonHidden: true,
      );
      result = await ScanbotSdkUi.startDocumentScanner(config);
    } catch (e) {
      print(e);
    }
    if (isOperationSuccessful(result)) {
      await _pageRepository.addPages(result.pages);
      _updatePagesList();
    }
  }

  void _showCleanupStorageDialog() {
    Widget text = SimpleDialogOption(
      child: Text('Delete all images and generated files (PDF, TIFF, etc)?'),
    );

    // set up the SimpleDialog
    final dialog = AlertDialog(
      title: const Text('Delete all'),
      content: text,
      contentPadding: EdgeInsets.all(0),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            _cleanupStorage();
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('CANCEL'),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  Future<void> _filterAllPages() async {
    if (!await _checkHasPages(context)) {
      return;
    }
    if (!await checkLicenseStatus(context)) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => MultiPageFiltering(_pageRepository)),
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

    final dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: 'Creating PDF ...');
    try {
      dialog.show();
      var options = PdfRenderingOptions(PdfRenderSize.A4);
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
      final image = await ImagePicker.pickImage(source: ImageSource.gallery);
      await _createPage(image.uri);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _createPage(Uri uri) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    var dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
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

  Future<void> _createTiff(bool binarized) async {
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
      var options = TiffCreationOptions(
          binarized: binarized,
          dpi: 200,
          compression: (binarized
              ? TiffCompression.CCITT_T6
              : TiffCompression.ADOBE_DEFLATE));
      final tiffFileUri =
          await ScanbotSdk.createTiff(_pageRepository.pages, options);
      await dialog.hide();
      await showAlertDialog(context, tiffFileUri.toString(),
          title: 'TIFF file URI');
    } catch (e) {
      print(e);
      await dialog.hide();
    }
  }

  Future<void> _detectPage(sdk.Page page) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }

    var dialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: 'Processing ...');
    dialog.show();
    try {
      var updatedPage = await ScanbotSdk.detectDocument(page);
      await dialog.hide();
      await _pageRepository.updatePage(updatedPage);
      _updatePagesList();
    } catch (e) {
      print(e);
      await dialog.hide();
    }
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
      final result = await ScanbotSdk.performOcr(_pages,
          OcrOptions(languages: ['en', 'de'], shouldGeneratePdf: false));
      await dialog.hide();
      await showAlertDialog(context, 'Plain text:\n' + result.plainText);
    } catch (e) {
      print(e);
      await dialog.hide();
    }
  }

  Future<void> _createOcrPdf() async {
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
      var result = await ScanbotSdk.performOcr(
          _pages, OcrOptions(languages: ['en', 'de'], shouldGeneratePdf: true));
      await dialog.hide();
      await showAlertDialog(
          context,
          'PDF File URI:\n' +
              result.pdfFileUri +
              '\n\nPlain text:\n' +
              result.plainText);
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

  void _updatePagesList() {
    imageCache.clear();
    setState(() {
      _pages = _pageRepository.pages;
    });
  }
}
