import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

import '../../../utility/utils.dart';

Future<void> startDocumentDetectionWithCroppingScreen(String imageFilePath) async {
  /**
   * Select an image from the Image Library
   * Return early if no image is selected or there is an issue selecting an image
   **/
  var imageFile = await selectImageFromLibrary();
  if (imageFile == null) {
    return;
  }

  /** Create a new document with the provided imageFileUri. */
  var params = CreateDocumentParams(
    imageFileUris: [imageFile.path]
  );
  var document = await ScanbotSdk.document.createDocument(params);
  /** Create a new configuration with the document and the document's first page. */
  var configuration = CroppingConfiguration(
    documentUuid: document.value!.uuid,
    pageUuid: document.value!.pages[0].uuid,
  );
  /* Customize the configuration. */
  configuration.cropping.bottomBar.rotateButton.visible = false;
  configuration.appearance.topBarBackgroundColor = ScanbotColor('#c8193c');
  configuration.cropping.topBarConfirmButton.foreground.color = ScanbotColor('#ffffff');
  configuration.localization.croppingTopBarCancelButtonTitle = 'Cancel';
  /** Start the cropping UI Screen */
  var documentResult = await ScanbotSdkUiV2.startCroppingScreen(configuration);
  /** Handle the document if the status is 'OK' */
  if (documentResult.status == OperationStatus.OK) {
  }
}