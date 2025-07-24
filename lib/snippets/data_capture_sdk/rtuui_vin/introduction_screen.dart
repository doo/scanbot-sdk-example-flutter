import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

Future<void> startScanning() async {
  // Create an instance of the default configuration
  var configuration = VinScannerScreenConfiguration();
  // Show the introduction screen automatically when the screen appears.
  configuration.introScreen.showAutomatically = true;
  // Configure the background color of the screen.
  configuration.introScreen.backgroundColor = ScanbotColor("#FFFFFF");

  // Configure the title for the intro screen.
  configuration.introScreen.title.text = "How to scan VIN";

  // Configure the image for the introduction screen.
  // If you want to have no image...
  configuration.introScreen.image = VinScannerIntroImage.vinIntroNoImage();
  // For a custom image...
  // configuration.introScreen.image = VinScannerIntroImage.vinIntroDefaultImage(uri: "PathToImage")
  // Or you can also use our default images.
  // e.g the meter device image.
  configuration.introScreen.image = VinScannerIntroImage.vinIntroDefaultImage();

  // Configure the color of the handler on top.
  configuration.introScreen.handlerColor = ScanbotColor("#EFEFEF");

  // Configure the color of the divider.
  configuration.introScreen.dividerColor = ScanbotColor("#EFEFEF");

  // Configure the text.
  configuration.introScreen.explanation.color = ScanbotColor("#000000");
  configuration.introScreen.explanation.text = "To scan a VIN (Vehicle Identification Number), please hold your device so that the camera viewfinder clearly captures the VIN code. Please ensure the VIN is properly aligned. Once the scan is complete, the VIN will be automatically extracted.\n\nPress 'Start Scanning' to begin.";

  // Configure the done button.
  // e.g the text or the background color.
  configuration.introScreen.doneButton.text = "Start Scanning";
  configuration.introScreen.doneButton.background.fillColor = ScanbotColor("#C8193C");

  /** Start the VIN Scanner **/
  var result = await ScanbotSdkUiV2.startVINScanner(configuration);
  if (result.status == OperationStatus.OK) {
    // ...
  }
}