import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = DocumentDataExtractorScreenConfiguration();
  // Start the Document Data Extractor
  var result = await ScanbotSdk.documentDataExtractor.startExtractorScreen(
    configuration,
  );

  if (result is Ok<DocumentDataExtractorUiResult>) {
    // Cast the resulted generic document to the appropriate document model.
    // Available document types are defined in [DocumentsModelRootType] enum.
    var documentModel = DeIdCardFront(result.value.document!);

    // Retrieve values from the German ID card front, e.g. to fill in a form.
    // Each field also provides a `confidence` value.
    var birthDate = documentModel.birthDate.value?.text;
    var birthplace = documentModel.birthplace.value?.text;
    var cardAccessNumber = documentModel.cardAccessNumber.value?.text;
    var expiryDate = documentModel.expiryDate.value?.text;
    var givenNames = documentModel.givenNames.value?.text;
    var id = documentModel.id.value?.text;
    var maidenName = documentModel.maidenName?.value?.text;
    var nationality = documentModel.nationality.value?.text;
    var surname = documentModel.surname.value?.text;
    var series = documentModel.series.value?.text;
  } else {
    // Handle the error or cancellation, e.g. show a message to the user.
  }
}
