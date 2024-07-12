import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;

import '../../main.dart';
import '../../pages_repository.dart';
import '../pages_widget.dart';
import '../preview_document_widget.dart';

/// This is an example screen of how to integrate new classical barcode scanner component
class DocumentScannerWidget extends StatefulWidget {
  const DocumentScannerWidget({Key? key}) : super(key: key);

  @override
  _DocumentScannerWidgetState createState() => _DocumentScannerWidgetState();
}

class _DocumentScannerWidgetState extends State<DocumentScannerWidget> {
  /// this stream only used if you need to show live scanned results on top of the camera
  /// otherwise we stop scanning and return first result out of the screen
  final resultStream = StreamController<sdk.Page>();
  final detectionStatusStream = StreamController<DetectionStatus>();

  late DocumentSnapTrigger generalSnapTrigger;
  bool permissionGranted = false;
  bool flashEnabled = false;
  bool autoSnappingEnabled = true;
  bool flashAvailable = false;
  bool showProgressBar = false;
  bool licenseIsActive = true;

  final PageRepository _pageRepository = PageRepository();

  void showPageResult(List<sdk.Page> pages) {
    _pageRepository.addPages(pages);
    Navigator.of(context)
        .push(
          MaterialPageRoute(builder: (context) => DocumentPreview()),
        )
        .then((value) {});
  }

  void checkPermission() async {
    // Don't forget to update ios Podfile according to the `permission_handler` official installation guide!! https://pub.dev/packages/permission_handler
    final permissionResult = await [Permission.camera].request();
    if (mounted) {
      setState(() {
        permissionGranted =
            permissionResult[Permission.camera]?.isGranted ?? false;
      });
    }
  }

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var documentClassicScannerConfiguration = DocumentClassicScannerConfiguration(
        // ignoreBadAspectRatio: false,
        autoSnapEnabled: autoSnappingEnabled,
        //initial autosnapping
        //acceptedAngleScore: 35,
        acceptedSizeScore: 75,
        /*  requiredAspectRatios: [
                                      const PageAspectRatio(
                                          width: 1.0, height: 1.0)
                                    ],*/
        detectDocumentAfterSnap: false,
        autoSnapSensitivity: 0.5);
    var documentCameraConfiguration = DocumentCameraConfiguration(
        flashEnabled: flashEnabled, //initial flash state
        // Initial configuration for the scanner itself
        scannerConfiguration: documentClassicScannerConfiguration,
        contourConfiguration: ContourConfiguration(
          showPolygonInManualMode: false,
          strokeOkColor: Colors.red,
          fillOkColor: Colors.red.withAlpha(150),
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withAlpha(150),
          cornerRadius: 35,
          strokeWidth: 10,
          autoSnapProgressStrokeColor: Colors.greenAccent,
          autoSnapProgressEnabled: true,
          autoSnapProgressStrokeWidth: 5,
        ));
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Scan Documents',
          style: TextStyle(
            inherit: true,
            color: Colors.black,
          ),
        ),
        actions: [
          if (permissionGranted && licenseIsActive)
            IconButton(
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      autoSnappingEnabled = !autoSnappingEnabled;
                    });
                  }
                },
                icon: Icon(autoSnappingEnabled
                    ? Icons.auto_mode_outlined
                    : Icons.disabled_by_default)),
          if (flashAvailable)
            IconButton(
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      flashEnabled = !flashEnabled;
                    });
                  }
                },
                icon: Icon(flashEnabled ? Icons.flash_on : Icons.flash_off)),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            // Check permission and show some placeholder if its not granted, or show camera otherwise
            licenseIsActive
                ? permissionGranted
                    ? Stack(
                        children: [
                          DocumentScannerCamera(
                            snapListener: (page) {
                              /// Use update function to show result overlay on top of the camera or
                              resultStream.add(page);

                              var pages = [page];

                              /// this to return result to screen caller
                              // Navigator.pop(context, pages);

                              /// for showing result in next screen in stack
                              showPageResult(pages);
                            },
                            errorListener: (error) {
                              if (mounted) {
                                setState(() {
                                  licenseIsActive = false;
                                });
                              }
                              Logger.root.severe(error.toString());
                            },
                            documentContourListener:
                                (DocumentContourScanningResult result) {
                              detectionStatusStream.add(result.detectionStatus);
                            },
                            // Camera on the bottom of the stack, should not be rebuild on each update of the stateful widget
                            configuration: documentCameraConfiguration,

                            onCameraPreviewStarted:
                                (snapTrigger, isFlashAvailable) => {
                              if (mounted)
                                {
                                  setState(() {
                                    generalSnapTrigger = snapTrigger;
                                    flashAvailable = isFlashAvailable;
                                  }),
                                },
                            },
                            onHeavyOperationProcessing: (show) {
                              setState(() {
                                showProgressBar = show;
                              });
                            },
                          ),
                          StreamBuilder<DetectionStatus>(
                              stream: detectionStatusStream.stream,
                              builder: (context, snapshot) {
                                if (snapshot.data == null ||
                                    !permissionGranted ||
                                    !licenseIsActive) {
                                  return Container();
                                }

                                return SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Center(
                                      child: Wrap(
                                        children: [
                                          DetectionStatusWidget(
                                            status: snapshot.data ??
                                                DetectionStatus
                                                    .ERROR_NOTHING_DETECTED,
                                          ),
                                        ],
                                      ),
                                    ));
                              }),
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: ShutterButton(
                                  onPressed: () {
                                    generalSnapTrigger();
                                  },
                                  autosnappingMode: autoSnappingEnabled,
                                  primaryColor: Colors.pink,
                                  accentColor: Colors.white,
                                  // animatedLineStrokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        child: const Text(
                          'Permissions not granted',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                : Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'License is No more active',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

            //result content on the top of the scanner as a stream builder, to optimize rebuilding of the widget on each success
            StreamBuilder<sdk.Page>(
                stream: resultStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  }
                  return autoSnappingEnabled
                      ? SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Align(
                            child: SizedBox(
                                width: 100,
                                height: 200,
                                child: FadeOutView(
                                    key: Key(snapshot.data?.pageId ?? ""),
                                    fadeDelay:
                                        const Duration(milliseconds: 500),
                                    child: PagePreview(page: snapshot.data!))),
                            alignment: Alignment.bottomRight,
                          ))
                      : Container();
                }),

            showProgressBar
                ? const Center(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        strokeWidth: 10,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  documentContour(DocumentContourScanningResult result) {}
}

class DetectionStatusWidget extends StatelessWidget {
  final DetectionStatus status;

  const DetectionStatusWidget({Key? key, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(150),
        borderRadius: const BorderRadiusDirectional.all(Radius.circular(5)),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Colors.green.withAlpha(150),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          status.name,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class PagePreview extends StatelessWidget {
  final sdk.Page page;

  const PagePreview({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var documentPreviewFile = File.fromUri(page.documentPreviewImageFileUri!);
    var originalPreviewFile = File.fromUri(page.originalPreviewImageFileUri!);
    var file = documentPreviewFile.existsSync()
        ? documentPreviewFile
        : originalPreviewFile;
    var imageUri = documentPreviewFile.existsSync()
        ? page.documentPreviewImageFileUri!
        : page.originalPreviewImageFileUri!;
    if (file.existsSync() == true) {
      if (shouldInitWithEncryption) {
        return SizedBox(
          height: 200,
          child: EncryptedPageWidget(imageUri),
        );
      } else {
        return SizedBox(
          height: 200,
          child: PageWidget(imageUri),
        );
      }
    }
    return Container();
  }
}
