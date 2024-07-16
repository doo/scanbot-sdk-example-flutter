import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

class GenericDocumentResultPreview extends StatefulWidget {
  final GenericDocumentResults result;

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
    var widgets = <Widget>[];
    for (var document in widget.result.documents) {
      widgets.add(genericDocumentResultView(document));
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
            'Generic Document Recognizer Result',
            style: TextStyle(
              inherit: true,
              color: Colors.black,
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: widgets.length,
          itemBuilder: (context, index) {
            return widgets[index];
          },
        ));
  }
}

Widget genericDocumentResultView(GenericDocument document) {
  switch (document.type.name) {
    case MRZ.DOCUMENT_TYPE:
      return MrzView(MRZ(document));
    case DeIdCardFront.DOCUMENT_TYPE:
      return DeIdCardFrontView(DeIdCardFront(document));
    case DeResidencePermitFront.DOCUMENT_TYPE:
      return DeResidencePermitFrontView(DeResidencePermitFront(document));
    case DeIdCardBack.DOCUMENT_TYPE:
      return DeIdCardBackView(DeIdCardBack(document));
    case DePassport.DOCUMENT_TYPE:
      return DePassportView(DePassport(document));
    case DeDriverLicenseFront.DOCUMENT_TYPE:
      return DeDriverLicenseFrontView(DeDriverLicenseFront(document));
    case DeDriverLicenseBack.DOCUMENT_TYPE:
      return DeDriverLicenseBackView(DeDriverLicenseBack(document));
    default:
      return Container();
  }
}

class DeDriverLicenseFrontView extends StatelessWidget {
  final DeDriverLicenseFront result;

  DeDriverLicenseFrontView(
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

class DeDriverLicenseBackView extends StatelessWidget {
  final DeDriverLicenseBack result;

  DeDriverLicenseBackView(
    this.result,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GenericDocumentFieldView(
          title: "Restriction",
          genericDocumentField: result.restrictions,
        ),
        CategoryView(
          title: "Category A",
          category: result.categories.a,
        ),
        CategoryView(
          title: "Category A1",
          category: result.categories.a1,
        ),
        CategoryView(
          title: "Category A2",
          category: result.categories.a2,
        ),
        CategoryView(
          title: "Category B",
          category: result.categories.b,
        ),
        CategoryView(
          title: "Category Be",
          category: result.categories.be,
        ),
        if (result.categories.b1 != null)
          CategoryView(
            title: "Category B1",
            category: result.categories.b1!,
          ),
        CategoryView(
          title: "Category C",
          category: result.categories.c,
        ),
        CategoryView(
          title: "Category Ce",
          category: result.categories.ce,
        ),
        CategoryView(
          title: "Category C1",
          category: result.categories.c1,
        ),
        CategoryView(
          title: "Category C1e",
          category: result.categories.c1E,
        ),
        CategoryView(
          title: "Category D",
          category: result.categories.d,
        ),
        CategoryView(
          title: "Category De",
          category: result.categories.de,
        ),
        CategoryView(
          title: "Category D1",
          category: result.categories.d1,
        ),
        CategoryView(
          title: "Category D1e",
          category: result.categories.d1E,
        ),
        CategoryView(
          title: "Category L",
          category: result.categories.l,
        ),
        CategoryView(
          title: "Category AM",
          category: result.categories.am,
        ),
        CategoryView(
          title: "Category T",
          category: result.categories.t,
        ),
      ],
    );
  }
}

class MrzView extends StatelessWidget {
  final MRZ result;

  MrzView(
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
          title: "Expiry Date",
          genericDocumentField: result.expiryDate,
        ),
        GenericDocumentFieldView(
          title: "Given Names",
          genericDocumentField: result.givenNames,
        ),
        GenericDocumentFieldView(
          title: "TravelDocType",
          genericDocumentField: result.travelDocType,
        ),
        GenericDocumentFieldView(
          title: "Document Number",
          genericDocumentField: result.documentNumber,
        ),
        GenericDocumentFieldView(
          title: "Nationality",
          genericDocumentField: result.nationality,
        ),
        GenericDocumentFieldView(
          title: "Pin",
          genericDocumentField: result.pinCode,
        ),
        GenericDocumentFieldView(
          title: "Surname",
          genericDocumentField: result.surname,
        ),
      ],
    );
  }
}

class DeIdCardFrontView extends StatelessWidget {
  final DeIdCardFront result;

  DeIdCardFrontView(
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
      ],
    );
  }
}

class DeResidencePermitFrontView extends StatelessWidget {
  final DeResidencePermitFront result;

  DeResidencePermitFrontView(
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
          genericDocumentField: result.birthDate,
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
      ],
    );
  }
}

class DeIdCardBackView extends StatelessWidget {
  final DeIdCardBack result;

  DeIdCardBackView(
    this.result,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          genericDocumentField: result.rawMRZ,
        ),
        MrzView(result.mrz),
      ],
    );
  }
}

class DePassportView extends StatelessWidget {
  final DePassport result;

  DePassportView(
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
          genericDocumentField: result.rawMRZ,
        ),
        MrzView(result.mrz),
      ],
    );
  }
}

class CategoryView extends StatelessWidget {
  final DeDriverLicenseBackCategory category;
  final String title;

  CategoryView({
    Key? key,
    required this.title,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey[300],
          child: Text(
            title,
          ),
        ),
        GenericDocumentFieldView(
          title: "Valid From",
          genericDocumentField: category.validFrom,
        ),
        GenericDocumentFieldView(
          title: "ValidUntil",
          genericDocumentField: category.validUntil,
        ),
        GenericDocumentFieldView(
          title: "Restriction",
          genericDocumentField: category.restrictions,
        ),
      ],
    );
  }
}

class GenericDocumentFieldView extends StatelessWidget {
  final TextFieldWrapper? genericDocumentField;
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
                      genericDocumentField?.value?.text ?? "",
                    ),
                    Text(
                      "(Confidence: ${((genericDocumentField?.value?.confidence ?? 1) * 100).toInt()}% )",
                    ),
                    if (genericDocumentField is ValidatedTextFieldWrapper)
                      Text((genericDocumentField as ValidatedTextFieldWrapper)
                              .validated
                          ? "Validated"
                          : "Not Validated")
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
