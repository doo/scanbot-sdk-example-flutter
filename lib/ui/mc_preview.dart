import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scanbot_sdk/mc_scanning_data.dart';
import 'package:scanbot_sdk_example_flutter/ui/pages_widget.dart';

import '../main.dart';

class MedicalCertificatePreviewWidget extends StatelessWidget {
  final MedicalCertificateResult preview;

  MedicalCertificatePreviewWidget(this.preview);

  @override
  Widget build(BuildContext context) {
    var checkboxes = <Widget>[];
    var patientInfos = <Widget>[];
    var dates = <Widget>[];
    for (var element in preview.checkboxes) {
      checkboxes.add(McInfoboxFieldItemWidget(element));
    }
    for (var element in preview.patientInfoFields) {
      patientInfos.add(McPatientInfoFieldItemWidget(element));
    }
    for (var element in preview.dates) {
      dates.add(McDateRecordFieldItemWidget(element));
    }
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
              if (position == 0) {
                return Column(children: checkboxes);
              }
              if (position == 1) {
                return Column(children: dates);
              }
              if (position == 2) {
                return Column(children: patientInfos);
              }
              if (position == 3) {
                return   getImageContainer(preview.croppedDocumentURI);
              }
              return Container();
            },
            itemCount: 4,
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
  final McPatientInfoField field;

  McPatientInfoFieldItemWidget(this.field);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Expanded(
        child: Row(
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
          ],
        ),
      ),
    );
  }
}

class McInfoboxFieldItemWidget extends StatelessWidget {
  final MedicalCertificateInfoBox field;

  McInfoboxFieldItemWidget(this.field);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                field.subType.name,
                style: const TextStyle(
                  inherit: true,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (field.hasContents).toString(),
                style: const TextStyle(
                  inherit: true,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
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
      child: Row(
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
        ],
      ),
    );
  }
}
