import 'package:flutter/material.dart';
import 'package:scanbot_sdk/generic_document_recognizer.dart';

class GenericDocumentResultPreview extends StatefulWidget {
  final GenericDocumentRecognizerResult result;
  GenericDocumentResultPreview(
    this.result,
  );

  @override
  State<GenericDocumentResultPreview> createState() =>
      _GenericDocumentResultPreviewState();
}

class _GenericDocumentResultPreviewState
    extends State<GenericDocumentResultPreview> {
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
          'Generic Document Recognizer Result',
          style: TextStyle(
            inherit: true,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: genericDocumentResultView(
            widget.result.documentType, widget.result.fields),
      ),
    );
  }
}

Widget genericDocumentResultView(
    GenericDocumentType? genericDocumentType, dynamic fields) {
  switch (genericDocumentType) {
    case GenericDocumentType.DeIdCard:
      return DeIdCardResultView(fields as DeIdCardResult);
    case GenericDocumentType.DePassport:
      return DePassportResultView(fields as DePassportResult);
    case GenericDocumentType.DeDriverLicense:
      return DeDriverLicenseResultView(fields as DeDriverLicenseResult);
    default:
      return Container();
  }
}

class DeDriverLicenseResultView extends StatelessWidget {
  final DeDriverLicenseResult result;
  DeDriverLicenseResultView(
    this.result,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GenericDocumentFieldView(
          title: "Birth Date",
          genericDocumentField: result.birthDate,
        ),
        GenericDocumentFieldView(
          title: "Birth Place",
          genericDocumentField: result.birthplace,
        ),
        GenericDocumentFieldView(
          title: "Expiry Date",
          genericDocumentField: result.expiryDate,
        ),
        GenericDocumentFieldView(
          title: "Given Names",
          genericDocumentField: result.givenNames,
        ),
        GenericDocumentFieldView(
          title: "Id",
          genericDocumentField: result.id,
        ),
        GenericDocumentFieldView(
          title: "Issue Date",
          genericDocumentField: result.issueDate,
        ),
        GenericDocumentFieldView(
          title: "Issuing Authority",
          genericDocumentField: result.issuingAuthority,
        ),
        GenericDocumentFieldView(
          title: "License Categories",
          genericDocumentField: result.licenseCategories,
        ),
        GenericDocumentFieldView(
          title: "Surname",
          genericDocumentField: result.surname,
        ),
      ],
    );
  }
}

class DeIdCardResultView extends StatelessWidget {
  final DeIdCardResult result;
  DeIdCardResultView(
    this.result,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GenericDocumentFieldView(
          title: "Birth Date",
          genericDocumentField: result.birthDate,
        ),
        GenericDocumentFieldView(
          title: "Birth Place",
          genericDocumentField: result.birthplace,
        ),
        GenericDocumentFieldView(
          title: "Expiry Date",
          genericDocumentField: result.expiryDate,
        ),
        GenericDocumentFieldView(
          title: "Given Names",
          genericDocumentField: result.givenNames,
        ),
        GenericDocumentFieldView(
          title: "Id",
          genericDocumentField: result.id,
        ),
        GenericDocumentFieldView(
          title: "Maiden Name",
          genericDocumentField: result.maidenName,
        ),
        GenericDocumentFieldView(
          title: "Nationality",
          genericDocumentField: result.nationality,
        ),
        GenericDocumentFieldView(
          title: "Pin",
          genericDocumentField: result.pin,
        ),
        GenericDocumentFieldView(
          title: "Surname",
          genericDocumentField: result.surname,
        ),
        GenericDocumentFieldView(
          title: "Address",
          genericDocumentField: result.address,
        ),
        GenericDocumentFieldView(
          title: "EyeColor",
          genericDocumentField: result.eyeColor,
        ),
        GenericDocumentFieldView(
          title: "Height",
          genericDocumentField: result.height,
        ),
        GenericDocumentFieldView(
          title: "Issue Date",
          genericDocumentField: result.issueDate,
        ),
        GenericDocumentFieldView(
          title: "Issuing Authority",
          genericDocumentField: result.issuingAuthority,
        ),
        GenericDocumentFieldView(
          title: "Pseudonym",
          genericDocumentField: result.pseudonym,
        ),
        GenericDocumentFieldView(
          title: "Raw Mrz",
          genericDocumentField: result.rawMrz,
        ),
      ],
    );
  }
}

class DePassportResultView extends StatelessWidget {
  final DePassportResult result;
  DePassportResultView(
    this.result,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GenericDocumentFieldView(
          title: "Birth Date",
          genericDocumentField: result.birthDate,
        ),
        GenericDocumentFieldView(
          title: "Birth Place",
          genericDocumentField: result.birthplace,
        ),
        GenericDocumentFieldView(
          title: "Country Code",
          genericDocumentField: result.countryCode,
        ),
        GenericDocumentFieldView(
          title: "Expiry Date",
          genericDocumentField: result.expiryDate,
        ),
        GenericDocumentFieldView(
          title: "Gender",
          genericDocumentField: result.gender,
        ),
        GenericDocumentFieldView(
          title: "Given Names",
          genericDocumentField: result.givenNames,
        ),
        GenericDocumentFieldView(
          title: "Id",
          genericDocumentField: result.id,
        ),
        GenericDocumentFieldView(
          title: "Issue Date",
          genericDocumentField: result.issueDate,
        ),
        GenericDocumentFieldView(
          title: "Issuing Authority",
          genericDocumentField: result.issuingAuthority,
        ),
        GenericDocumentFieldView(
          title: "Maiden Name",
          genericDocumentField: result.maidenName,
        ),
        GenericDocumentFieldView(
          title: "Nationality",
          genericDocumentField: result.nationality,
        ),
        GenericDocumentFieldView(
          title: "Passport Type",
          genericDocumentField: result.passportType,
        ),
        GenericDocumentFieldView(
          title: "Surname",
          genericDocumentField: result.surname,
        ),
        GenericDocumentFieldView(
          title: "Raw Mrz",
          genericDocumentField: result.rawMrz,
        ),
      ],
    );
  }
}

class GenericDocumentFieldView extends StatelessWidget {
  final GenericDocumentField? genericDocumentField;
  final String title;
  GenericDocumentFieldView({
    required this.title,
    required this.genericDocumentField,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Column(
        children: [
          const Divider(
            thickness: 2,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      genericDocumentField?.text ?? "",
                    ),
                    Text(
                      "(Confidence: ${((genericDocumentField?.confidence ?? 1) * 100).toInt()}% )",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
