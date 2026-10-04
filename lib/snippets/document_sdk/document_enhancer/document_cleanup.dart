import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> startDocumentCleanup(String documentUuid, String pageUuid) async {
  final configuration = DocumentCleanupStandaloneConfiguration(
    documentUuid: documentUuid,
    pageUuid: pageUuid,
  );

  // If true, the cleanup tool will not allow erasing text. But it takes some time to process OCR on the image initially.
  configuration.cleanup.engineConfiguration.keepText = false;

  // The maximum number of undo/redo operations that can be performed. Make it smaller to save up memory.
  configuration.cleanup.engineConfiguration.maxUndoRedoStackSize = 4;

  // Downscales the stroke area to this value in pixels (width x height) to speed up the cleanup process. The smaller the value the faster but the quality will be lower too.
  configuration.cleanup.engineConfiguration.maxCleanupResolution = 1200000;

  // Customize the top bar.
  configuration.cleanup.topBarBackButton.text = 'Cancel';
  configuration.cleanup.topBarConfirmButton.text = 'Done';
  configuration.cleanup.topBarTitle.text = 'Clean up the page';

  // Background color of the cleanup screen.
  configuration.cleanup.backgroundColor = ScanbotColor('#222222');

  // Configure the toolbar buttons (undo / redo / reset).
  configuration.cleanup.toolbar.undoButton.title.text = 'Undo';
  configuration.cleanup.toolbar.redoButton.title.text = 'Redo';
  configuration.cleanup.toolbar.resetButton.title.text = 'Reset';

  configuration.cleanup.toolbar.strokeSizeSlider
    ..visible = true
    ..minStrokeSize = 1
    ..maxStrokeSize = 50
    ..title.text = 'Brush size';

  // Optional: show an introduction screen the first time the user opens cleanup.
  configuration.cleanup.introduction.showAutomatically = true;

  // Customize the alert dialogs shown for Reset and for cancelling with unsaved changes.
  configuration.cleanup.resetAllEditsAlertDialog.title.text =
      'Reset all edits?';
  configuration.cleanup.resetAllEditsAlertDialog.subtitle.text =
      'This will revert all cleanup operations on this page.';

  configuration.cleanup.discardChangesAlertDialog.title.text =
      'Discard changes?';
  configuration.cleanup.discardChangesAlertDialog.subtitle.text =
      'Your cleanup edits on this page will be lost.';

  final result = await ScanbotSdk.documentEnhancer.startDocumentCleanupScreen(
    configuration,
  );

  if (result is Ok<DocumentData>) {
    // Handle the updated document result, e.g. display the cleaned-up page.
  } else {
    // Handle the error, e.g. show a message to the user.
  }
}
