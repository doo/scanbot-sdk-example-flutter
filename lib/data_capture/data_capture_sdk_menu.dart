import 'package:flutter/material.dart';

import '../utility/utils.dart';
import 'data_capture_use_cases.dart';

class DataCaptureSdkMenu extends StatelessWidget {
  const DataCaptureSdkMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ScanbotRedColor,
        title: const Text('Scanbot Data Capture SDK Menu'),
      ),
      body: ListView(
        children: const <Widget>[
          DataCaptureUseCases(),
        ],
      ),
    );
  }
}

