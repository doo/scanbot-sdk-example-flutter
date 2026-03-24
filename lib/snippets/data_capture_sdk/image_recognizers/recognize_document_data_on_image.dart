import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> extractDocumentData(String uriPath) async {
  var commonConfig = DocumentDataExtractorCommonConfiguration(
    acceptedDocumentTypes: [
      DeIdCardFront.DOCUMENT_TYPE,
      DeIdCardBack.DOCUMENT_TYPE,
      DeHealthInsuranceCardFront.DOCUMENT_TYPE,
      DePassport.DOCUMENT_TYPE,
      DeResidencePermitFront.DOCUMENT_TYPE,
      DeResidencePermitBack.DOCUMENT_TYPE,
      EuropeanHealthInsuranceCard.DOCUMENT_TYPE,
      EuropeanDriverLicenseFront.DOCUMENT_TYPE,
      EuropeanDriverLicenseBack.DOCUMENT_TYPE,
    ],
  );

  var configuration = DocumentDataExtractorConfiguration(
    configurations: [commonConfig],
  );
  // Configure other parameters as needed.

  var result = await ScanbotSdk.documentDataExtractor.extractFromImageFileUri(
    uriPath,
    configuration,
  );
  if (result is Ok<DocumentDataExtractionResult> &&
      result.value.status == DocumentDataExtractionStatus.OK) {
    /** Handle the result **/
  } else {
    print(result.toString());
  }
}

String formatGenericDocumentResult(DocumentDataExtractionResult result) {
  return "DocumentType: ${result.document?.type.fullName}";
}
