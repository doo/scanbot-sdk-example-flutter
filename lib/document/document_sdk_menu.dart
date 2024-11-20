import 'package:flutter/material.dart';
import 'package:scanbot_sdk_example_flutter/document/_legacy_document_use_cases.dart';

import '../utility/utils.dart';
import 'document_use_cases.dart';

class DocumentSdkMenu extends StatelessWidget {
  const DocumentSdkMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ScanbotRedColor,
        title: const Text('Scanbot Document SDK Menu'),
      ),
      body: ListView(
        children: <Widget>[
          const DocumentUseCasesWidget(),
          DocumentUseCasesLegacyWidget(),
        ],
      ),
    );
  }
}

