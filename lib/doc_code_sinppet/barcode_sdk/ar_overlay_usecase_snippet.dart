import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _startBarcodeScanner() async {
    // Create the default configuration object.
    var configuration = BarcodeScannerConfiguration();

    // TODO: configure as needed

    var result = await ScanbotSdkUi.startBarcodeScanner(configuration);

    if (result.operationResult == OperationResult.SUCCESS) {
      // TODO: present barcode result as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          height: 200,
          minWidth: 200,
          color: Colors.blue,
          textColor: Colors.white,
          child: const Text("Start Barcode Scanner"),
          onPressed: _startBarcodeScanner,
        ),
      ),
    );
  }
}