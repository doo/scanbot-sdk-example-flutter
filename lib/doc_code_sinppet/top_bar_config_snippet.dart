import 'package:scanbot_sdk/scanbot_sdk_v2.dart';

void topBarConfigSnippet() {
  // Create the default configuration object.
  var configuration = BarcodeScannerConfiguration();

  // Configure the top bar.

  // Set the top bar mode.
  configuration.topBar.mode = TopBarMode.GRADIENT;

  // Set the background color which will be used as a gradient.
  configuration.topBar.backgroundColor = ScanbotColor("#C8193C");

  // Configure the status bar look. If visible - select DARK or LIGHT according to your app's theme color.
  configuration.topBar.statusBarMode = StatusBarMode.HIDDEN;

  // Configure the Cancel button.
  configuration.topBar.cancelButton.text = "Cancel";
  configuration.topBar.cancelButton.foreground.color = ScanbotColor("#FFFFFF");

  // Configure other parameters as needed.
}
