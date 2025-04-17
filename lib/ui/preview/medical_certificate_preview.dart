import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';
import 'package:scanbot_sdk_example_flutter/ui/pages_widget.dart';

import '../../utility/utils.dart';

class MedicalCertificatePreviewWidget extends StatelessWidget {
  final MedicalCertificateScanningResult preview;

  MedicalCertificatePreviewWidget(this.preview);

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    for (var element in preview.checkBoxes!) {
      widgets.add(McInfoboxFieldItemWidget(element));
    }
    for (var element in preview.patientInfoBox!.fields) {
      widgets.add(McPatientInfoFieldItemWidget(element));
    }
    for (var element in preview.dates!) {
      widgets.add(McDateRecordFieldItemWidget(element));
    }
    // widgets.add(getImageContainer(preview.croppedImage));
    return Scaffold(
      appBar: ScanbotAppBar('Scanned Certificate', showBackButton: true, context: context),
      body: ListView.builder(
        itemBuilder: (context, position) {
          return widgets[position];
        },
        itemCount: widgets.length,
      ),
    );
  }

  Widget getImageContainer(Uri? imageUri) {
    if (imageUri == null) {
      return Container();
    }

    var file = File.fromUri(imageUri);
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

class McPatientInfoFieldItemWidget extends StatelessWidget {
  final MedicalCertificatePatientInfoField field;

  McPatientInfoFieldItemWidget(this.field);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              field.type.name,
              style: const TextStyle(
                inherit: true,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (field.value).toString(),
              style: const TextStyle(
                inherit: true,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (field.recognitionConfidence).toString(),
              style: const TextStyle(
                inherit: true,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class McInfoboxFieldItemWidget extends StatelessWidget {
  final MedicalCertificateCheckBox checkbox;

  McInfoboxFieldItemWidget(this.checkbox);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              checkbox.type.name,
              style: const TextStyle(
                inherit: true,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (checkbox.type).toString(),
              style: const TextStyle(
                inherit: true,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (checkbox.checkedConfidence).toString(),
              style: const TextStyle(
                inherit: true,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class McDateRecordFieldItemWidget extends StatelessWidget {
  final MedicalCertificateDateRecord field;

  McDateRecordFieldItemWidget(this.field);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              field.type.name,
              style: const TextStyle(
                inherit: true,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (field.type).toString(),
              style: const TextStyle(
                inherit: true,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (field.recognitionConfidence).toString(),
              style: const TextStyle(
                inherit: true,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
