import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

GenericDocumentRecognizerConfiguration genericDocumentRecognizerConfigurationSnippet() {
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

  return config;
}


Future<void> runDocumentPageScanner() async {
  var config = genericDocumentRecognizerConfigurationSnippet();
  var result = await ScanbotSdkUi.startGenericDocumentRecognizer(config);

  if (result.operationResult == OperationResult.SUCCESS) {
    GenericDocumentWrapper? wrappedDocument;

    for (var document in result.documents) {
      wrappedDocument = _wrapDocument(document);
      if (wrappedDocument != null) {
        // Perform operations with `wrappedDocument` if needed
        break; // Exit loop if the document is successfully wrapped
      }
    }
  }
}

GenericDocumentWrapper? _wrapDocument(GenericDocument document) {
  switch (document.type.name) {
    case MRZ.DOCUMENT_TYPE:
      return MRZ(document);
    case DeIdCardFront.DOCUMENT_TYPE:
      return DeIdCardFront(document);
    case DeResidencePermitFront.DOCUMENT_TYPE:
      return DeResidencePermitFront(document);
    case DeResidencePermitBack.DOCUMENT_TYPE:
      return DeResidencePermitBack(document);
    case DeIdCardBack.DOCUMENT_TYPE:
      return DeIdCardBack(document);
    case DePassport.DOCUMENT_TYPE:
      return DePassport(document);
    case DeDriverLicenseFront.DOCUMENT_TYPE:
      return DeDriverLicenseFront(document);
    case DeDriverLicenseBack.DOCUMENT_TYPE:
      return DeDriverLicenseBack(document);
    default:
      return null;
  }
}

