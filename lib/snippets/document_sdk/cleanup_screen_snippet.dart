import 'package:scanbot_sdk/scanbot_sdk.dart';

void startCleanup() async {
  // Create the default configuration object.
  var configuration = DocumentScanningFlow();

  // Reveal the 'Clean up' button in the review screen's toolbar. It is hidden by default.
  configuration.screens.review.toolbar.documentCleanupButton.barButton.visible =
      true;

  // Retrieve the instance of the cleanup configuration from the main configuration object.
  var cleanupScreenConfiguration = configuration.screens.cleanup;
  // Configure the toolbar buttons. They are enabled by default.
  cleanupScreenConfiguration.toolbar.undoButton.visible = true;
  cleanupScreenConfiguration.toolbar.redoButton.visible = true;
  // Configure various colors.
  configuration.appearance.topBarBackgroundColor = ScanbotColor('#C8193C');
  cleanupScreenConfiguration.topBarConfirmButton.foreground.color =
      ScanbotColor('#FFFFFF');
  // Customize a UI element's text
  configuration.localization.documentCleanupTopBarCancelButtonTitle = 'Cancel';
  // Start the Document Scanner UI
  var documentResult = await ScanbotSdk.document.startScanner(configuration);
  // Handle the document if the result is 'Ok'
  if (documentResult is Ok<DocumentData>) {
    var documentData = documentResult.value;
    // Display the scanned pages, or export the document as PDF/TIFF.
  } else {
    // Handle the error or cancellation, e.g. show a message to the user.
  }
}
