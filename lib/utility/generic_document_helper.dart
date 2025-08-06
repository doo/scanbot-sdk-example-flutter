import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

class GenericDocumentHelper {
  static Widget wrappedGenericDocumentField(GenericDocument? genericDocument) {
    if (genericDocument == null) return const SizedBox.shrink();

    final wrappedGenericFieldValue = _getGenericFieldValue(genericDocument);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '''
Document: ${genericDocument.type.name}
Field: ${wrappedGenericFieldValue?.type.name ?? "N/A"}
Value: ${wrappedGenericFieldValue?.value?.text ?? "N/A"}
''',
        style: const TextStyle(inherit: true, color: Colors.black),
      ),
    );
  }

  static TextFieldWrapper? _getGenericFieldValue(GenericDocument genericDocument) {
    switch (genericDocument.type.name) {
      case BoardingPass.DOCUMENT_TYPE:
        return BoardingPass(genericDocument).electronicTicketIndicator;
      case SwissQR.DOCUMENT_TYPE:
        return SwissQR(genericDocument).iban;
      case DEMedicalPlan.DOCUMENT_TYPE:
        return DEMedicalPlan(genericDocument).doctor.issuerName;
      case IDCardPDF417.DOCUMENT_TYPE:
        return IDCardPDF417(genericDocument).dateExpired;
      case GS1.DOCUMENT_TYPE:
        return GS1(genericDocument).elements.first.applicationIdentifier;
      case SEPA.DOCUMENT_TYPE:
        return SEPA(genericDocument).receiverIBAN;
      case MedicalCertificate.DOCUMENT_TYPE:
        return MedicalCertificate(genericDocument).doctorNumber;
      case VCard.DOCUMENT_TYPE:
        return VCard(genericDocument).name?.rawValue;
      case AAMVA.DOCUMENT_TYPE:
        return AAMVA(genericDocument).issuerIdentificationNumber;
      default:
        return null;
    }
  }
}
