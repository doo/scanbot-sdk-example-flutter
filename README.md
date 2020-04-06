# Scanbot SDK Example Flutter

This example app shows how to integrate the [Scanbot SDK Flutter Plugin](https://pub.dev/packages/scanbot_sdk) on Android and iOS.

For more details about the Plugin please see this [documentation](https://scanbotsdk.github.io/documentation/flutter/).


## What is Scanbot SDK?

The Scanbot SDK brings scanning and document creation capabilities to your mobile apps. 
It contains modules which are individually licensable as license packages. 
For more details visit our website https://scanbot.io


## How to run this app

Install [Flutter](https://flutter.dev) and all required dev tools.
 
Fetch this repository and navigate to the project directory.

```
cd scanbot-sdk-example-flutter/
```

Fetch and install the dependencies of this example project via Flutter CLI:

```
flutter pub get
```

Connect a mobile device via USB and run the app.

**Android:**

```
flutter run -d <DEVICE_ID>
```

You can get the IDs of all connected devices via `flutter devices`.

**iOS:**

Install Pods dependencies:

```
cd ios/
pod install --repo-update
```

Open the **workspace**(!) `ios/Runner.xcworkspace` in Xcode and adjust the *Signing / Developer Account* settings. 
Then build and run the app in Xcode.


## Please note

The Scanbot SDK will run without a license for one minute per session!

After the trial period is over all Scanbot SDK functions as well as the UI components (like Document Scanner UI) will 
stop working or may be terminated. You have to restart the app to get another trial period.

To get an unrestricted "no-strings-attached" 30 day trial license, please submit the [Trial License Form](https://scanbot.io/en/sdk/demo/trial) on our website.
