import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

class ExtractedDocumentDataPreview extends StatelessWidget {
  final DocumentDataExtractorUiResult? uiResult;
  final DocumentDataExtractionResult? scanningResult;

  const ExtractedDocumentDataPreview({
    super.key,
    this.uiResult,
    this.scanningResult,
  }) : assert(uiResult != null || scanningResult != null,
  'At least one result must be provided');

  @override
  Widget build(BuildContext context) {
    final document = uiResult?.document ?? scanningResult?.document;
    final croppedImage = uiResult?.croppedImage ?? scanningResult?.croppedImage;

    final children = <Widget>[
      _buildImagePreview(croppedImage),
      const SizedBox(height: 16),
    ];

    void addField(String title, String? value, double? confidence, {bool largeGap = false}) {
      children.add(Text(title, style: Theme.of(context).textTheme.titleMedium));
      if (value != null && value.isNotEmpty) {
        children.add(Text(value, style: Theme.of(context).textTheme.bodyMedium));
      }
      if (confidence != null && confidence.isFinite) {
        children.add(Text('Confidence: ${confidence.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.labelSmall));
      }
      children.add(SizedBox(height: largeGap ? 16 : 12));
    }

    if (document == null) {
      children.add(const Text('No data available for this document'));
    } else {
      switch (document.type.name) {
        case MRZ.DOCUMENT_TYPE:
          final mrz = MRZ(document);
          addField('Birth Date', mrz.birthDate.value?.text, mrz.birthDate.value?.confidence);
          addField('Expiry Date', mrz.expiryDate?.value?.text, mrz.expiryDate?.value?.confidence);
          addField('Given Names', mrz.givenNames.value?.text, mrz.givenNames.value?.confidence);
          addField('TravelDocType', mrz.travelDocType?.value?.text, mrz.travelDocType?.value?.confidence);
          addField('Document Number', mrz.documentNumber?.value?.text, mrz.documentNumber?.value?.confidence);
          addField('Nationality', mrz.nationality.value?.text, mrz.nationality.value?.confidence);
          addField('Pin', mrz.pinCode?.value?.text, mrz.pinCode?.value?.confidence);
          addField('Surname', mrz.surname.value?.text, mrz.surname.value?.confidence);
          break;
        case DeHealthInsuranceCardFront.DOCUMENT_TYPE:
          final hic = DeHealthInsuranceCardFront(document);
          addField('Name', hic.name.value?.text, hic.name.value?.confidence);
          addField('CardAccessNumber', hic.cardAccessNumber?.value?.text, hic.cardAccessNumber?.value?.confidence);
          addField('IssuerName', hic.issuerName.value?.text, hic.issuerName.value?.confidence);
          addField('IssuerNumber', hic.issuerNumber.value?.text, hic.issuerNumber.value?.confidence);
          addField('PersonalNumber', hic.personalNumber.value?.text, hic.personalNumber.value?.confidence);
          break;
        case DeIdCardFront.DOCUMENT_TYPE:
          final doc = DeIdCardFront(document);
          addField('Birth Date', doc.birthDate.value?.text, doc.birthDate.value?.confidence);
          addField('Birth Place', doc.birthplace.value?.text, doc.birthplace.value?.confidence);
          addField('Expiry Date', doc.expiryDate.value?.text, doc.expiryDate.value?.confidence);
          addField('Given Names', doc.givenNames.value?.text, doc.givenNames.value?.confidence);
          addField('Id', doc.id.value?.text, doc.id.value?.confidence);
          addField('Maiden Name', doc.maidenName?.value?.text, doc.maidenName?.value?.confidence);
          addField('Nationality', doc.nationality.value?.text, doc.nationality.value?.confidence);
          addField('Surname', doc.surname.value?.text, doc.surname.value?.confidence);
          break;
        case DeResidencePermitFront.DOCUMENT_TYPE:
          final doc = DeResidencePermitFront(document);
          addField('Birth Date', doc.birthDate?.value?.text, doc.birthDate?.value?.confidence);
          addField('Birth Place', doc.birthDate?.value?.text, doc.birthDate?.value?.confidence);
          addField('Expiry Date', doc.expiryDate.value?.text, doc.expiryDate.value?.confidence);
          addField('Given Names', doc.givenNames.value?.text, doc.givenNames.value?.confidence);
          addField('Id', doc.id.value?.text, doc.id.value?.confidence);
          addField('Nationality', doc.nationality?.value?.text, doc.nationality?.value?.confidence);
          addField('Surname', doc.surname.value?.text, doc.surname.value?.confidence);
          break;
        case DeResidencePermitBack.DOCUMENT_TYPE:
          final doc = DeResidencePermitBack(document);
          addField('Address', doc.address.value?.text, doc.address.value?.confidence);
          addField('Birth Date', doc.birthDate?.value?.text, doc.birthDate?.value?.confidence);
          addField('Eye Color', doc.eyeColor.value?.text, doc.eyeColor.value?.confidence);
          addField('Gender', doc.gender?.value?.text, doc.gender?.value?.confidence);
          addField('Height', doc.height.value?.text, doc.height.value?.confidence);
          addField('Issuing Authority', doc.issuingAuthority.value?.text, doc.issuingAuthority.value?.confidence);
          addField('Nationality', doc.nationality?.value?.text, doc.nationality?.value?.confidence);
          addField('Raw MRZ', doc.rawMRZ.value?.text, doc.rawMRZ.value?.confidence);
          addField('Remarks', doc.remarks?.value?.text, doc.remarks?.value?.confidence);
          break;
        case DeIdCardBack.DOCUMENT_TYPE:
          final doc = DeIdCardBack(document);
          addField('Address', doc.address.value?.text, doc.address.value?.confidence);
          addField('Eye Color', doc.eyeColor.value?.text, doc.eyeColor.value?.confidence);
          addField('Height', doc.height.value?.text, doc.height.value?.confidence);
          addField('Issue Date', doc.issueDate.value?.text, doc.issueDate.value?.confidence);
          addField('Issuing Authority', doc.issuingAuthority.value?.text, doc.issuingAuthority.value?.confidence);
          addField('Pseudonym', doc.pseudonym?.value?.text, doc.pseudonym?.value?.confidence);
          addField('Raw MRZ', doc.rawMRZ.value?.text, doc.rawMRZ.value?.confidence);
          break;
        case DePassport.DOCUMENT_TYPE:
          final doc = DePassport(document);
          addField('Birth Date', doc.birthDate.value?.text, doc.birthDate.value?.confidence);
          addField('Birth Place', doc.birthplace.value?.text, doc.birthplace.value?.confidence);
          addField('Country Code', doc.countryCode.value?.text, doc.countryCode.value?.confidence);
          addField('Expiry Date', doc.expiryDate.value?.text, doc.expiryDate.value?.confidence);
          addField('Gender', doc.gender.value?.text, doc.gender.value?.confidence);
          addField('Given Names', doc.givenNames.value?.text, doc.givenNames.value?.confidence);
          addField('Id', doc.id.value?.text, doc.id.value?.confidence);
          addField('Issue Date', doc.issueDate.value?.text, doc.issueDate.value?.confidence);
          addField('Issuing Authority', doc.issuingAuthority.value?.text, doc.issuingAuthority.value?.confidence);
          addField('Maiden Name', doc.maidenName?.value?.text, doc.maidenName?.value?.confidence);
          addField('Nationality', doc.nationality.value?.text, doc.nationality.value?.confidence);
          addField('Passport Type', doc.passportType.value?.text, doc.passportType.value?.confidence);
          addField('Surname', doc.surname.value?.text, doc.surname.value?.confidence);
          addField('Raw MRZ', doc.rawMRZ.value?.text, doc.rawMRZ.value?.confidence);
          break;
        case EuropeanHealthInsuranceCard.DOCUMENT_TYPE:
          final doc = EuropeanHealthInsuranceCard(document);
          addField('Barcode', doc.barcode?.value?.text, doc.barcode?.value?.confidence);
          addField('BirthDate', doc.expiryDate.value?.text, doc.expiryDate.value?.confidence);
          addField('CardNumber', doc.cardNumber.value?.text, doc.cardNumber.value?.confidence);
          addField('CountryCode', doc.countryCode.value?.text, doc.countryCode.value?.confidence);
          addField('ExpiryDate', doc.expiryDate.value?.text, doc.expiryDate.value?.confidence);
          addField('GivenNames', doc.givenNames.value?.text, doc.givenNames.value?.confidence);
          addField('IssuerName', doc.issuerName.value?.text, doc.issuerName.value?.confidence);
          addField('IssuerNumber', doc.issuerNumber.value?.text, doc.issuerNumber.value?.confidence);
          addField('PersonalNumber', doc.personalNumber.value?.text, doc.personalNumber.value?.confidence);
          addField('Signature', doc.signature?.value?.text, doc.signature?.value?.confidence);
          addField('Surname', doc.surname.value?.text, doc.surname.value?.confidence);
          break;
        case EuropeanDriverLicenseFront.DOCUMENT_TYPE:
          final doc = EuropeanDriverLicenseFront(document);
          addField('BirthDate', doc.expiryDate.value?.text, doc.expiryDate.value?.confidence);
          addField('Issue Date', doc.issueDate?.value?.text, doc.issueDate?.value?.confidence);
          addField('Issuing Authority', doc.issuingAuthority?.value?.text, doc.issuingAuthority?.value?.confidence);
          addField('ExpiryDate', doc.expiryDate.value?.text, doc.expiryDate.value?.confidence);
          addField('GivenNames', doc.givenNames.value?.text, doc.givenNames.value?.confidence);
          addField('LicenseCategories', doc.licenseCategories?.value?.text, doc.licenseCategories?.value?.confidence);
          addField('Photo', doc.photo.value?.text, doc.photo.value?.confidence);
          addField('SerialNumber', doc.serialNumber?.value?.text, doc.serialNumber?.value?.confidence);
          addField('Signature', doc.signature.value?.text, doc.signature.value?.confidence);
          addField('Surname', doc.surname.value?.text, doc.surname.value?.confidence);
          break;
        case EuropeanDriverLicenseBack.DOCUMENT_TYPE:
          final doc = EuropeanDriverLicenseBack(document);
          addField('Restrictions', doc.restrictions?.value?.text, doc.restrictions?.value?.confidence);
          addField('Categories A1', doc.categories.a1.validFrom?.value?.text, doc.categories.a1.validFrom?.value?.confidence);
          addField('Categories A2', doc.categories.a2.validFrom?.value?.text, doc.categories.a2.validFrom?.value?.confidence);
          addField('Categories B1', doc.categories.b1?.validFrom?.value?.text, doc.categories.b1?.validFrom?.value?.confidence);
          //...
          break;
        default:
          children.add(const Text('Unsupported document type'));
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildImagePreview(ImageRef? image) {
    if (image?.buffer != null) {
      return Image.memory(image!.buffer!, fit: BoxFit.contain);
    } else {
      return const Text('No image available');
    }
  }
}