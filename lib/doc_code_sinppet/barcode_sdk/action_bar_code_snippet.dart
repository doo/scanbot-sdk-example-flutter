import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

void actionBarConfigSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();

  // Configure the action bar.
  // Hide/unhide the flash button.
  configuration.actionBar.flashButton.visible = true;

  // Configure the inactive state of the flash button.
  configuration.actionBar.flashButton.backgroundColor =
      ScanbotColor("#7A000000");
  configuration.actionBar.flashButton.foregroundColor = ScanbotColor("#FFFFFF");

  // Configure the active state of the flash button.
  configuration.actionBar.flashButton.activeBackgroundColor =
      ScanbotColor("#FFCE5C");
  configuration.actionBar.flashButton.activeForegroundColor =
      ScanbotColor("#000000");

  // Hide/unhide the zoom button.
  configuration.actionBar.zoomButton.visible = true;

  // Configure the inactive state of the zoom button.
  configuration.actionBar.zoomButton.backgroundColor =
      ScanbotColor("#7A000000");
  configuration.actionBar.zoomButton.foregroundColor = ScanbotColor("#FFFFFF");
  // Zoom button has no active state - it only switches between zoom levels (for configuring those please refer to camera configuring).

  // Hide/unhide the flip camera button.
  configuration.actionBar.flipCameraButton.visible = true;

  // Configure the inactive state of the flip camera button.
  configuration.actionBar.flipCameraButton.backgroundColor =
      ScanbotColor("#7A000000");
  configuration.actionBar.flipCameraButton.foregroundColor =
      ScanbotColor("#FFFFFF");
  // Flip camera button has no active state - it only switches between front and back camera.

  // Configure other parameters as needed.
}
