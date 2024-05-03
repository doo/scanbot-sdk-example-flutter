import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;

import '../../pages_repository.dart';

/// This is an example screen of how to integrate new classical barcode scanner component
class CroppingScreenWidget extends StatefulWidget {
  CroppingScreenWidget({Key? key, required this.page}) : super(key: key);

  final sdk.Page page;

  @override
  _CroppingScreenWidgetState createState() => _CroppingScreenWidgetState(page);
}

class _CroppingScreenWidgetState extends State<CroppingScreenWidget> {
  final PageRepository _pageRepository = PageRepository();
  sdk.Page currentPage;

  /// this stream only used if you need to show live scanned results on top of the camera
  /// otherwise we stop scanning and return first result out of the screen
  bool showProgressBar = false;
  bool doneButtonEnabled = true;

  CroppingController? croppingController;

  _CroppingScreenWidgetState(this.currentPage);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            'Crop document',
            style: TextStyle(
              inherit: true,
              color: Colors.black,
            ),
          ),
          actions: [
            if (doneButtonEnabled)
              IconButton(
                  onPressed: () {
                    cropAndPop();
                  },
                  icon: const Icon(Icons.done)),
          ],
        ),
        body: Stack(
          children: <Widget>[
            // Check permission and show some placeholder if its not granted, or show camera otherwise
            ScanbotCroppingWidget(
                page: currentPage,
                onViewReady: (controller) {
                  croppingController = controller;
                },
                onHeavyOperationProcessing: (isProcessing) {
                  setState(() {
                    showProgressBar = isProcessing;
                  });
                },
                edgeColor: Colors.red,
                edgeColorOnLine: Colors.blue,
                anchorPointsColor: Colors.amberAccent,
                borderInsets: sdk.Insets.all(16)),

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
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  croppingController?.reset();
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(inherit: true, color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  croppingController?.detect();
                },
                child: const Text(
                  'Detect',
                  style: TextStyle(inherit: true, color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (!doneButtonEnabled) return;
                  //disable done button while processing rotation animation with await
                  setState(() {
                    doneButtonEnabled = false;
                  });
                  croppingController?.rotateCw().then((value) => {
                        setState(() {
                          doneButtonEnabled = true;
                        })
                      });
                },
                child: const Text(
                  'Rotate Cw',
                  style: TextStyle(inherit: true, color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }

  Future<sdk.Page> proceedImage(
      sdk.Page page, CroppingPolygon croppingResult) async {
    //transform rotation degrees to rotation times (each time is 90degree) + direction

    return await ScanbotSdk.cropAndRotatePage(
        page, croppingResult.polygon, croppingResult.rotationTimesCw);
  }

  cropAndPop() async {
    setState(() {
      showProgressBar = true;
    });
    var croppingResult = await croppingController?.getPolygon();
    setState(() {
      showProgressBar = false;
    });
    if (croppingResult != null) {
      var newPage = proceedImage(currentPage, croppingResult);
      Navigator.of(context).pop(newPage);
    }
  }
}
