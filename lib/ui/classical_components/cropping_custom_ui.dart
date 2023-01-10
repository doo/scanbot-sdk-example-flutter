import 'package:flutter/material.dart';
import 'package:scanbot_sdk/classical_components/classical_cropping.dart';
import 'package:scanbot_sdk/json/common_data.dart' as common;
import 'package:scanbot_sdk/scanbot_sdk.dart';

/// This is an example screen of how to integrate new classical barcode scanner component
class CroppingScreenWidget extends StatefulWidget {
  CroppingScreenWidget({Key? key, required this.page}) : super(key: key);
  final common.Page page;

  @override
  _CroppingScreenWidgetState createState() => _CroppingScreenWidgetState();
}

class _CroppingScreenWidgetState extends State<CroppingScreenWidget> {
  /// this stream only used if you need to show live scanned results on top of the camera
  /// otherwise we stop scanning and return first result out of the screen
  bool showProgressBar = false;
  CroppingController? croppingController;

  _CroppingScreenWidgetState() {}

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
            IconButton(
                onPressed: () {
                  cropAndPop();
                },
                icon: const Icon(Icons.done))
          ],
        ),
        body: Stack(
          children: <Widget>[
            // Check permission and show some placeholder if its not granted, or show camera otherwise
            ScanbotCroppingWidget(
                page: widget.page,
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
                borderInsets: common.Insets.all(16)),

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
                  croppingController?.rotateCw();
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

  Future<common.Page> proceedImage(
      common.Page page, CroppingResult croppingResult) async {
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
      var newPage = proceedImage(widget.page, croppingResult);
      Navigator.of(context).pop(newPage);
    }
  }
}
