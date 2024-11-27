import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as scanbot_sdk;

import '../../main.dart';
import '../../utility/utils.dart';
import '../operations_page_widget.dart';
import '../pages_widget.dart';

import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

class DocumentPreview extends StatefulWidget {
  final DocumentData initialDocumentData;

  DocumentPreview(this.initialDocumentData);

  @override
  DocumentPreviewPreviewState createState() => DocumentPreviewPreviewState();
}

class DocumentPreviewPreviewState extends State<DocumentPreview> {

  late DocumentData documentData;

  @override
  void initState() {
    super.initState();
    documentData = widget.initialDocumentData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScanbotAppBar('Document Result'),
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
                  final imageUri = Uri(path: documentData.pages[position].documentImagePreviewURI!.replaceFirst('file://', ''));
                  final pageView = shouldInitWithEncryption
                      ? EncryptedPageWidget(imageUri)
                      : PageWidget(imageUri);

                  return GridTile(
                    child: GestureDetector(
                      onTap: () => _showOperationsPage(documentData.pages[position]),
                      child: pageView,
                    ),
                  );
                },
                itemCount: documentData.pages.length,
              ),
            ),
          ),
          BottomAppBar(
            color: ScanbotRedColor,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildButton('Continue\nscanning', _continueScanning),
                _buildButton('Add Page', _addPage),
                _buildButton('Export', _exportSheet),
                _buildButton('Delete All', _deleteAllPages),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String label,
    VoidCallback onPressed
  ) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  void _exportSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Save as PDF'),
              onTap: _saveDocumentAsPDF,
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Save as PDF with OCR'),
              onTap: _saveDocumentAsPDFWithOCR,
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Save as TIFF (1-bit B&W)'),
              onTap: _saveDocumentAsTIFFBinarized,
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Save as TIFF (color)'),
              onTap: _saveDocumentAsTIFF,
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => { Navigator.pop(context) },
            ),
          ],
        );
      },
    );
  }

  Future<void> startScan({
    required BuildContext context,
    required Future<ResultWrapper<DocumentData>> Function() scannerFunction,
  }) async {
    if (!await checkLicenseStatus(context)) {
      return;
    }
    try {
      var result = await scannerFunction();
      if (result.status == OperationStatus.OK &&
          result.value != null) {
        setState(() {
          documentData = result.value!;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showOperationsPage(PageData page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PageOperations(documentData.uuid, page)),
    );

    var loadedData = await ScanbotSdkUi.loadDocument(documentData.uuid);
    if(loadedData.value == null) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        documentData = loadedData.value!;
      });
    }
  }

  Future<void> _continueScanning() async {
    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotSdkUi.startDocumentScanner(DocumentScanningFlow(documentUuid: documentData.uuid)),
    );
  }

  Future<void> _addPage() async {
    final response = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (response?.path.isNotEmpty ?? false) {
      var result = await ScanbotSdkUi.addPage(AddPageParams(documentID: documentData.uuid, imageFileUri: response!.path));
      if (result.status == OperationStatus.OK &&
          result.value != null) {
        setState(() {
          documentData = result.value!;
        });
      }
    }
  }

  Future<void> _deleteAllPages() async {
    var result = await ScanbotSdkUi.removeAllPages(documentData.uuid);
    if (result.status == OperationStatus.OK &&
        result.value != null) {
      setState(() {
        documentData = result.value!;
      });
    }
  }

  Future<void> _saveDocumentAsPDF() async {
    var result = await ScanbotSdkUi.createPDFForDocument(PDFFromDocumentParams(documentID: documentData.uuid));
    if (result.status == OperationStatus.OK &&
        result.value != null) {
      await showAlertDialog(context, 'Pdf File created: ${result.value?.pdfFileUri}', title: 'Result');
    }
    Navigator.pop(context);
  }

  Future<void> _saveDocumentAsPDFWithOCR() async {
    var pdfOptions = scanbot_sdk.PdfRenderingOptions(
      pageSize: scanbot_sdk.PageSize.A4,
      pageDirection: scanbot_sdk.PageDirection.PORTRAIT,
      ocrConfiguration: scanbot_sdk.OcrOptions(engineMode: scanbot_sdk.OcrEngine.SCANBOT_OCR)
    );

    var result = await ScanbotSdkUi.createPDFForDocument(PDFFromDocumentParams(documentID: documentData.uuid, options: pdfOptions));
    if (result.status == OperationStatus.OK &&
        result.value != null) {
      await showAlertDialog(context, 'Pdf File created: ${result.value?.pdfFileUri}', title: 'Result');
    }
    Navigator.pop(context);
  }

  Future<void> _saveDocumentAsTIFFBinarized() async {
    var options = scanbot_sdk.TiffCreationOptions.withScanbotBinarizationFilter(scanbot_sdk.ScanbotBinarizationFilter(), dpi: 300, compression: scanbot_sdk.TiffCompression.CCITT_T6);
    var result = await ScanbotSdkUi.createTIFFForDocument(TIFFFromDocumentParams(documentID: documentData.uuid, options: options));
    if (result.status == OperationStatus.OK &&
        result.value != null) {
      await showAlertDialog(context, 'Tiff Binarized File created: ${result.value?.tiffFileUri}', title: 'Result');
    }
    Navigator.pop(context);
  }

  Future<void> _saveDocumentAsTIFF() async {
    var result = await ScanbotSdkUi.createTIFFForDocument(TIFFFromDocumentParams(documentID: documentData.uuid));
    if (result.status == OperationStatus.OK &&
        result.value != null) {
      await showAlertDialog(context, 'Tiff File created: ${result.value?.tiffFileUri}', title: 'Result');
    }
    Navigator.pop(context);
  }
}
