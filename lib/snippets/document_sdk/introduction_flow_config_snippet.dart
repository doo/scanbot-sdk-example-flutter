import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

DocumentScanningFlow introductionConfigurationScanningFlow() {
  // Create the default configuration object.
  var configuration = DocumentScanningFlow();

  // Configure the introduction screen
  configuration.screens.camera.introduction = IntroductionScreenConfiguration()
    ..showAutomatically = true
    ..items = [
      // Create the first introduction item
      IntroListEntry()
        ..image = IntroImage.receiptsIntroImage()
        ..text = StyledText(
          text: "Some text explaining how to scan a receipt",
          color: ScanbotColor("#000000"),
        ),
      // Create the second introduction item
      IntroListEntry()
        ..image = IntroImage.checkIntroImage()
        ..text = StyledText(
          text: "Some text explaining how to scan a check",
          color: ScanbotColor("#000000"),
        ),
    ]
    ..title = StyledText(
      text: "Introduction",
      color: ScanbotColor("#000000"),
    );

  return configuration;
}

void runDocumentScanner() async {
  var configuration = introductionConfigurationScanningFlow();
  await ScanbotSdkUiV2.startDocumentScanner(configuration);
}
