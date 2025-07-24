import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = DocumentDataExtractorScreenConfiguration();
  // Start the Document Data Extractor
  var result = await ScanbotSdkUiV2.startDocumentDataExtractor(configuration);
  if (result.status == OperationStatus.OK) {
    // Cast the resulted generic document to the appropriate document model.
    // Available document types are defined in [DocumentsModelRootType] enum.
    var documentModel = DeIdCardFront(result.data!.document!);

    // Retrieve values from the German ID card front
    print('Birth date: ${documentModel.birthDate.value?.text}, Confidence: ${documentModel.birthDate.value?.confidence}');
    print('Birthplace: ${documentModel.birthplace.value?.text}, Confidence: ${documentModel.birthplace.value?.confidence}');
    print('Card access number: ${documentModel.cardAccessNumber.value?.text}, Confidence: ${documentModel.cardAccessNumber.value?.confidence}');
    print('Expiry date: ${documentModel.expiryDate.value?.text}, Confidence: ${documentModel.expiryDate.value?.confidence}');
    print('Given names: ${documentModel.givenNames.value?.text}, Confidence: ${documentModel.givenNames.value?.confidence}');
    print('ID: ${documentModel.id.value?.text}, Confidence: ${documentModel.id.value?.confidence}');
    print('Maiden name: ${documentModel.maidenName?.value?.text}, Confidence: ${documentModel.maidenName?.value?.confidence}');
    print('Nationality: ${documentModel.nationality.value?.text}, Confidence: ${documentModel.nationality.value?.confidence}');
    print('Surname: ${documentModel.surname.value?.text}, Confidence: ${documentModel.surname.value?.confidence}');
    print('Series: ${documentModel.series.value?.text}, Confidence: ${documentModel.series.value?.confidence}');
  }
}