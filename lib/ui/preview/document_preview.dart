import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:scanbot_sdk/scanbot_sdk.dart' as scanbot_sdk;

import '../../utility/utils.dart';
import '../operations_page_widget.dart';
import '../pages_widget.dart';

import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

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
              padding: const material.EdgeInsets.all(8.0),
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
          result.data != null) {
        setState(() {
          documentData = result.data!;
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

    var loadedData = await ScanbotSdk.document.loadDocument(documentData.uuid);
    setState(() {
      documentData = loadedData;
    });
  }

  Future<void> _continueScanning() async {
    await startScan(
      context: context,
      scannerFunction: () =>
          ScanbotSdkUiV2.startDocumentScanner(DocumentScanningFlow(documentUuid: documentData.uuid)),
    );
  }

  Future<void> _addPage() async {
    final response = await selectImageFromLibrary();

    if (response?.path.isNotEmpty ?? false) {
      var result = await ScanbotSdk.document.addPage(AddPageParams(documentID: documentData.uuid, imageFileUri: response!.path));
      setState(() {
        documentData = result;
      });
    }
  }

  Future<void> _deleteAllPages() async {
    var result = await ScanbotSdk.document.removeAllPages(documentData.uuid);
    setState(() {
      documentData = result;
    });
  }

  Future<void> _saveDocumentAsPDF() async {
    var result = await ScanbotSdk.document.createPDFForDocument(PDFFromDocumentParams(documentID: documentData.uuid, pdfConfiguration: PdfConfiguration()));
    await showAlertDialog(context, 'Pdf File created: ${result.pdfFileUri}', title: 'Result');
  }

  Future<void> _saveDocumentAsPDFWithOCR() async {
    var pdfOptions = PdfConfiguration(
      pageSize: PageSize.A4,
      pageDirection: PageDirection.PORTRAIT,
    );

    var result = await ScanbotSdk.document.createPDFForDocument(PDFFromDocumentParams(documentID: documentData.uuid, pdfConfiguration: pdfOptions, ocrConfiguration: scanbot_sdk.OcrOptions(engineMode: scanbot_sdk.OcrEngine.SCANBOT_OCR)));
    await showAlertDialog(context, 'Pdf File created: ${result.pdfFileUri}', title: 'Result');
  }

  Future<void> _saveDocumentAsTIFFBinarized() async {
    var options = TiffGeneratorParameters(binarizationFilter: ScanbotBinarizationFilter(), dpi: 300, compression: CompressionMode.CCITT_T6);
    var result = await ScanbotSdk.document.createTIFFForDocument(TIFFFromDocumentParams(documentID: documentData.uuid, configuration: options));
    await showAlertDialog(context, 'Tiff Binarized File created: ${result.tiffFileUri}', title: 'Result');
  }

  Future<void> _saveDocumentAsTIFF() async {
    var result = await ScanbotSdk.document.createTIFFForDocument(TIFFFromDocumentParams(documentID: documentData.uuid, configuration: TiffGeneratorParameters()));
    await showAlertDialog(context, 'Tiff File created: ${result.tiffFileUri}', title: 'Result');
  }
}
