import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

class GenericDocumentHelper {
  static Widget wrappedGenericDocumentField(GenericDocument? genericDocument) {
    if (genericDocument == null) return Container();

    TextFieldWrapper? wrappedGenericFieldValue;

    switch (genericDocument.type?.name) {
      case BoardingPass.DOCUMENT_TYPE:
        wrappedGenericFieldValue =
            BoardingPass(genericDocument).electronicTicket;
        break;
      case SwissQR.DOCUMENT_TYPE:
        wrappedGenericFieldValue = SwissQR(genericDocument).iban;
        break;

      case DEMedicalPlan.DOCUMENT_TYPE:
        wrappedGenericFieldValue =
            DEMedicalPlan(genericDocument).doctor.issuerName;
        break;

      case IDCardPDF417.DOCUMENT_TYPE:
        wrappedGenericFieldValue = IDCardPDF417(genericDocument).dateExpired;
        break;

      case GS1.DOCUMENT_TYPE:
        wrappedGenericFieldValue =
            GS1(genericDocument).elements.first.applicationIdentifier;
        break;

      case SEPA.DOCUMENT_TYPE:
        SEPA(genericDocument).receiverIBAN;
        break;

      case MedicalCertificate.DOCUMENT_TYPE:
        MedicalCertificate(genericDocument).doctorNumber;
        break;

      case VCard.DOCUMENT_TYPE:
        VCard(genericDocument).firstName;
        break;

      case AAMVA.DOCUMENT_TYPE:
        AAMVA(genericDocument).driverLicense;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
          "Document: ${genericDocument.type?.name} \nField: ${wrappedGenericFieldValue?.type.name} \nValue: ${wrappedGenericFieldValue?.value?.text}",
          style: const TextStyle(inherit: true, color: Colors.black)),
    );
  }
}
