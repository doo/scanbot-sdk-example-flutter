import 'package:image_picker/image_picker.dart';
import 'package:scanbot_sdk_example_flutter/ui/progress_dialog.dart';
import 'package:scanbot_sdk_example_flutter/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:scanbot_sdk/common_data.dart' as c;
import 'package:scanbot_sdk/create_tiff_data.dart';
import 'package:scanbot_sdk/document_scan_data.dart';
import 'package:scanbot_sdk/ocr_data.dart';
import 'package:scanbot_sdk/render_pdf_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

import '../pages_repository.dart';
import 'filter_all_pages_widget.dart';
import 'operations_page_widget.dart';
import 'pages_widget.dart';

class DocumentPreview extends StatelessWidget {
  final PageRepository _pageRepository;

  DocumentPreview(this._pageRepository);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: const Text('Image results',
              style: TextStyle(inherit: true, color: Colors.black)),
        ),
        body: PagesPreviewWidget(this._pageRepository));
  }
}

class PagesPreviewWidget extends StatefulWidget {
  final PageRepository _pageRepository;

  PagesPreviewWidget(this._pageRepository);

  @override
  State<PagesPreviewWidget> createState() {
    return new PagesPreviewWidgetState(this._pageRepository);
  }
}

class PagesPreviewWidgetState extends State<PagesPreviewWidget> {
  List<c.Page > pages;
  final PageRepository _pageRepository;
  int currentSelectedPage = 0;

  PagesPreviewWidgetState(this._pageRepository) {
    this.pages = _pageRepository.pages;
  }

  void _updatePagesList() {
    imageCache.clear();
    Future.delayed(Duration(microseconds: 500)).then((val) {
      setState(() {
        this.pages = _pageRepository.pages;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200),
                    itemBuilder: (context, position) {
                      return GridTile(
                        child: GestureDetector(
                            onTap: () {
                              showOperationsPage(pages[position]);
                            },
                            child: PageWidget(
                                pages[position].documentPreviewImageFileUri)),
                      );
                    },
                    itemCount: pages?.length ?? 0))),
        BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.add_circle),
                    Container(width: 4),
                    Text('Add',
                        style: TextStyle(inherit: true, color: Colors.black)),
                  ],
                ),
                onPressed: () {
                  _addPageModalBottomSheet(context);
                },
              ),
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.more_vert),
                    Container(width: 4),
                    Text('More',
                        style: TextStyle(inherit: true, color: Colors.black)),
                  ],
                ),
                onPressed: () {
                  _settingModalBottomSheet(context);
                },
              ),
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete, color: Colors.red),
                    Container(width: 4),
                    Text('Delete All',
                        style: TextStyle(inherit: true, color: Colors.red)),
                  ],
                ),
                onPressed: () {
                  showCleanupStorageDialog();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  showOperationsPage(c.Page  page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => PageOperations(page, _pageRepository)),
    );
    _updatePagesList();
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                ListTile(
                  leading: new Icon(Icons.text_fields),
                  title: new Text('Perform OCR'),
                  onTap: () {
                    Navigator.pop(context);
                    performOcr();
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.picture_as_pdf),
                  title: new Text('Save as PDF'),
                  onTap: () {
                    Navigator.pop(context);
                    createPdf();
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.picture_as_pdf),
                  title: new Text('Save as PDF with OCR'),
                  onTap: () {
                    Navigator.pop(context);
                    createOcrPdf();
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Safe as TIFF'),
                  onTap: () {
                    Navigator.pop(context);
                    createTiff(false);
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Save as TIFF 1-bit encoded'),
                  onTap: () {
                    Navigator.pop(context);
                    createTiff(true);
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Apply Image Filter on ALL pages'),
                  onTap: () {
                    Navigator.pop(context);
                    filterAllPages();
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.close),
                  title: new Text('Cancel'),
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
            child: new Wrap(
              children: <Widget>[
                ListTile(
                  leading: new Icon(Icons.scanner),
                  title: new Text('Scan Page'),
                  onTap: () {
                    Navigator.pop(context);
                    startDocumentScanning();
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.photo_size_select_actual),
                  title: new Text('Import Page'),
                  onTap: () {
                    Navigator.pop(context);
                    importImage();
                  },
                ),
                ListTile(
                  leading: new Icon(Icons.close),
                  title: new Text('Cancel'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }

  startDocumentScanning() async {
    if (!await checkLicenseStatus(context)) { return; }

    DocumentScanningResult result;
    try {
      var config = DocumentScannerConfiguration(
        orientationLockMode: c.CameraOrientationMode.PORTRAIT,
        cameraPreviewMode: c.CameraPreviewMode.FIT_IN,
        ignoreBadAspectRatio: true,
        multiPageEnabled: false,
        multiPageButtonHidden: true,
      );
      result = await ScanbotSdkUi.startDocumentScanner(config);
    } catch (e) {
      print(e);
    }
    if (isOperationSuccessful(result)) {
      _pageRepository.addPages(result.pages);
      _updatePagesList();
    }
  }

  showCleanupStorageDialog() {
    Widget text = SimpleDialogOption(
      child:
          Text("Delete all images and generated files (PDF, TIFF, etc)?"),
    );

    // set up the SimpleDialog
    AlertDialog dialog = AlertDialog(
      title: const Text('Delete all'),
      content: text,
      contentPadding: EdgeInsets.all(0),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            cleanupStorage();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
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

  filterAllPages() async {
    if (!await checkHasPages(context)) { return; }
    if (!await checkLicenseStatus(context)) { return; }

    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => MultiPageFiltering(_pageRepository)),
    );
  }

  cleanupStorage() async {
    try {
      await ScanbotSdk.cleanupStorage();
      _pageRepository.clearPages();
      _updatePagesList();
    } catch (e) {
      print(e);
    }
  }

  createPdf() async {
    if (!await checkHasPages(context)) { return; }
    if (!await checkLicenseStatus(context)) { return; }

    var dialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: "Creating PDF ...");
    try {
      dialog.show();
      var options = PdfRenderingOptions(PdfRenderSize.A4);
      final Uri pdfFileUri = await ScanbotSdk.createPdf(this._pageRepository.pages, options);
      dialog.hide();
      showAlertDialog(context, pdfFileUri.toString(), title: "PDF file URI");
    } catch (e) {
      print(e);
      dialog.hide();
    }
  }

  importImage() async {
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      createPage(image.uri);
    } catch (e) {}
  }

  createPage(Uri uri) async {
    if (!await checkLicenseStatus(context)) { return; }

    var dialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: "Processing ...");
    dialog.show();
    try {
      var page = await ScanbotSdk.createPage(uri, false);
      page = await ScanbotSdk.detectDocument(page);
      dialog.hide();
      this._pageRepository.addPage(page);
      _updatePagesList();
    } catch (e) {
      print(e);
      dialog.hide();
    }
  }

  createTiff(bool binarized) async {
    if (!await checkHasPages(context)) { return; }
    if (!await checkLicenseStatus(context)) { return; }

    var dialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: "Creating TIFF ...");
    dialog.show();
    try {
      var options = TiffCreationOptions(binarized: binarized, dpi: 200, compression: (binarized ? TiffCompression.CCITT_T6 : TiffCompression.ADOBE_DEFLATE));
      final Uri tiffFileUri = await ScanbotSdk.createTiff(this._pageRepository.pages, options);
      dialog.hide();
      showAlertDialog(context, tiffFileUri.toString(), title: "TIFF file URI");
    } catch (e) {
      print(e);
      dialog.hide();
    }
  }

  detectPage(c.Page page) async {
    if (!await checkLicenseStatus(context)) { return; }

    var dialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: "Processing ...");
    dialog.show();
    try {
      var updatedPage = await ScanbotSdk.detectDocument(page);
      dialog.hide();
      setState(() {
        this._pageRepository.updatePage(updatedPage);
        _updatePagesList();
      });
    } catch (e) {
      print(e);
      dialog.hide();
    }
  }

  performOcr() async {
    if (!await checkHasPages(context)) { return; }
    if (!await checkLicenseStatus(context)) { return; }

    var dialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: "Performing OCR ...");
    dialog.show();
    try {
      var result = await ScanbotSdk.performOcr(
          pages, OcrOptions(languages: ["en", "de"], shouldGeneratePdf: false));
      dialog.hide();
      showAlertDialog(context, "Plain text:\n" + result.plainText);
    } catch (e) {
      print(e);
      dialog.hide();
    }
  }

  createOcrPdf() async {
    if (!await checkHasPages(context)) { return; }
    if (!await checkLicenseStatus(context)) { return; }

    var dialog = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    dialog.style(message: "Performing OCR with PDF ...");
    dialog.show();
    try {
      var result = await ScanbotSdk.performOcr(
          pages, OcrOptions(languages: ["en", "de"], shouldGeneratePdf: true));
      dialog.hide();
      showAlertDialog(context, "PDF File URI:\n" + result.pdfFileUri +
          "\n\nPlain text:\n" + result.plainText);
    } catch (e) {
      print(e);
      dialog.hide();
    }
  }

  Future<bool> checkHasPages(BuildContext context) async {
    if (pages.isNotEmpty) {
      return true;
    }
    await showAlertDialog(context, 'Please scan or import some documents to perform this function.', title: 'Info');
    return false;
  }

}
