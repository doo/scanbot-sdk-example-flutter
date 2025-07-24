import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = DocumentDataExtractorScreenConfiguration();
  // Show the introduction screen automatically when the screen appears.
  configuration.introScreen.showAutomatically = true;

  // Configure the background color of the screen.
  configuration.introScreen.backgroundColor = ScanbotColor("#FFFFFF");

  // Configure the title for the intro screen.
  configuration.introScreen.title.text = "How to scan a document";

  // Configure the image for the introduction screen.
  // If you want to have no image...
  configuration.introScreen.image = DocumentDataExtractorIntroImage.documentDataIntroNoImage();
  // For a custom image...
  // configuration.introScreen.image = DocumentDataExtractorIntroImage.documentDataIntroCustomImage(uri: "PathToImage")
  // Or you can also use our default image.
  configuration.introScreen.image = DocumentDataExtractorIntroImage.documentDataIntroDefaultImage();

  // Configure the color of the handler on top.
  configuration.introScreen.handlerColor = ScanbotColor("#EFEFEF");

  // Configure the color of the divider.
  configuration.introScreen.dividerColor = ScanbotColor("#EFEFEF");

  // Configure the text.
  configuration.introScreen.explanation.color = ScanbotColor("#000000");
  configuration.introScreen.explanation.text = "To quickly and securely scan your document details, please hold your device over the document, so that the camera aligns with all the information on the document.\n\nThe scanner will guide you to the optimal scanning position. Once the scan is complete, your document details will automatically be extracted and processed.\n\nPress 'Start Scanning' to begin.";

  // Configure the done button.
  // e.g the text or the background color.
  configuration.introScreen.doneButton.text = "Start Scanning";
  configuration.introScreen.doneButton.background.fillColor = ScanbotColor("#C8193C");

  // Start the DDE
  var result = await ScanbotSdkUiV2.startDocumentDataExtractor(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}