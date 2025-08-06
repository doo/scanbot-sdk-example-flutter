import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> extractDocumentData(String uriPath) async {
  var commonConfig = DocumentDataExtractorCommonConfiguration(acceptedDocumentTypes: [
      DeIdCardFront.DOCUMENT_TYPE,
      DeIdCardBack.DOCUMENT_TYPE,
      DeHealthInsuranceCardFront.DOCUMENT_TYPE,
      DePassport.DOCUMENT_TYPE,
      DeResidencePermitFront.DOCUMENT_TYPE,
      DeResidencePermitBack.DOCUMENT_TYPE,
      EuropeanHealthInsuranceCard.DOCUMENT_TYPE,
      EuropeanDriverLicenseFront.DOCUMENT_TYPE,
      EuropeanDriverLicenseBack.DOCUMENT_TYPE,
    ]);

    var configuration = DocumentDataExtractorConfiguration(
      configurations: [commonConfig],
    );
    // Configure other parameters as needed.

  DocumentDataExtractionResult result = await ScanbotSdk.recognizeOperations.extractDocumentDataFromImage(uriPath, configuration);
  if (result.status == DocumentDataExtractionStatus.SUCCESS) {
    //  ...
  }
}

String formatGenericDocumentResult(DocumentDataExtractionResult result) {
    return "DocumentType: ${result.document?.type.fullName}";
}