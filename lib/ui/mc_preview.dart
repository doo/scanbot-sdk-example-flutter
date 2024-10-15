import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk_example_flutter/ui/pages_widget.dart';

import '../main.dart';

class MedicalCertificatePreviewWidget extends StatelessWidget {
  final MedicalCertificateResult preview;

  MedicalCertificatePreviewWidget(this.preview);

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    for (var element in preview.checkboxes!) {
      widgets.add(McInfoboxFieldItemWidget(element));
    }
    for (var element in preview.patientInfoBox!.fields) {
      widgets.add(McPatientInfoFieldItemWidget(element));
    }
    for (var element in preview.dates!) {
      widgets.add(McDateRecordFieldItemWidget(element));
    }
    widgets.add(getImageContainer(preview.croppedDocumentURI));
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
          'Scanned Certificate',
          style: TextStyle(
            inherit: true,
            color: Colors.black,
          ),
        ),
      ),
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
              field.patientInfoFieldType.name,
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
              (field.confidenceValue).toString(),
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
              (checkbox.hasContents).toString(),
              style: const TextStyle(
                inherit: true,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (checkbox.contentsValidationConfidenceValue).toString(),
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
  final DateRecord field;

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
              (field.dateString).toString(),
              style: const TextStyle(
                inherit: true,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (field.recognitionConfidenceValue).toString(),
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
