import 'package:flutter/material.dart';

import '../utility/utils.dart';
import '_legacy_use_cases.dart';
import 'data_capture_use_cases.dart';

class DataCaptureSdkMenu extends StatelessWidget {
  const DataCaptureSdkMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScanbotAppBar('Scanbot Data Capture SDK Menu'),
      body: ListView(
        children: const <Widget>[
          DataCaptureUseCases(),
          LegacyDataCaptureUseCases(),
        ],
      ),
    );
  }
}

