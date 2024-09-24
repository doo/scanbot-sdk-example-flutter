import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> runDocumentPageScanner() async {
  var config = GenericDocumentRecognizerConfiguration(
    acceptedDocumentTypes: [
      GenericDocumentType.DE_RESIDENCE_PERMIT_FRONT,
      GenericDocumentType.DE_RESIDENCE_PERMIT_BACK,
      GenericDocumentType.DE_DRIVER_LICENSE_FRONT,
      GenericDocumentType.DE_DRIVER_LICENSE_BACK,
      GenericDocumentType.DE_ID_CARD_FRONT,
      GenericDocumentType.DE_ID_CARD_BACK,
      GenericDocumentType.DE_PASSPORT,
    ],
    topBarBackgroundColor: Colors.red,
    fieldConfidenceLowColor: Colors.blue,
    fieldConfidenceHighColor: Colors.purpleAccent,
    fieldsDisplayConfiguration: [
      // All types of documents have its own class for field signatures, 
      // e.g. DeIdCardFront -> DeIdCardFrontFieldsSignatures. 
      // From this classes you can take field signatures for each field you want to configure.
      FieldsDisplayConfiguration(DeDriverLicenseFrontFieldNames.Surname,
          "My Surname", FieldDisplayState.ALWAYS_VISIBLE),
      FieldsDisplayConfiguration(
          DeDriverLicenseFrontFieldNames.GivenNames,
          "My GivenNames",
          FieldDisplayState.ALWAYS_VISIBLE),
      FieldsDisplayConfiguration(DeDriverLicenseFrontFieldNames.BirthDate,
          "My Birth Date", FieldDisplayState.ALWAYS_VISIBLE),
      FieldsDisplayConfiguration(
          DeDriverLicenseFrontFieldNames.ExpiryDate,
          "Document Expiry Date",
          FieldDisplayState.ALWAYS_VISIBLE),
      FieldsDisplayConfiguration(DeResidencePermitBackFieldNames.Address,
          "My address", FieldDisplayState.ALWAYS_VISIBLE),
      FieldsDisplayConfiguration(
          DeResidencePermitBackFieldNames.IssuingAuthority,
          "Who issued",
          FieldDisplayState.ALWAYS_VISIBLE),
      FieldsDisplayConfiguration(MRZFieldNames.DocumentNumber,
          "My Doc Num", FieldDisplayState.ALWAYS_VISIBLE),
      FieldsDisplayConfiguration(MRZFieldNames.Surname, "My Surname",
          FieldDisplayState.ALWAYS_VISIBLE),
    ],
    documentsDisplayConfiguration: [
      DocumentsDisplayConfiguration(
          DeIdCardBack.DOCUMENT_NORMALIZED_TYPE, "Id Card Back Side"),
      DocumentsDisplayConfiguration(
          DePassport.DOCUMENT_NORMALIZED_TYPE, "Passport"),
      DocumentsDisplayConfiguration(
          MRZ.DOCUMENT_NORMALIZED_TYPE, "MRZ on document back"),
      DocumentsDisplayConfiguration(
          DeDriverLicenseFront.DOCUMENT_NORMALIZED_TYPE,
          "Licence plate Front"),
      DocumentsDisplayConfiguration(
          DeDriverLicenseBack.DOCUMENT_NORMALIZED_TYPE,
          "Licence plate Back"),
    ]
  );

  var result = await ScanbotSdkUi.startGenericDocumentRecognizer(config);

  if (result.operationResult == OperationResult.SUCCESS) {
    GenericDocumentWrapper? wrapped_document;
    // see the array `result.documents`
    for (var document in result.documents) {
        switch (document.type.name) {
        case MRZ.DOCUMENT_TYPE:
          wrapped_document = MRZ(document);
          break;
        case DeIdCardFront.DOCUMENT_TYPE:
          wrapped_document = DeIdCardFront(document);
          break;
        case DeResidencePermitFront.DOCUMENT_TYPE:
          wrapped_document = DeResidencePermitFront(document);
          break;
        case DeResidencePermitBack.DOCUMENT_TYPE:
          wrapped_document = DeResidencePermitBack(document);
          break;
        case DeIdCardBack.DOCUMENT_TYPE:
          wrapped_document = DeIdCardBack(document);
          break;
        case DePassport.DOCUMENT_TYPE:
          wrapped_document = DePassport(document);
          break;
        case DeDriverLicenseFront.DOCUMENT_TYPE:
          wrapped_document = DeDriverLicenseFront(document);
          break;
        case DeDriverLicenseBack.DOCUMENT_TYPE:
          wrapped_document = DeDriverLicenseBack(document);
          break;
        default:
          return;
      }
    }
  }
}
