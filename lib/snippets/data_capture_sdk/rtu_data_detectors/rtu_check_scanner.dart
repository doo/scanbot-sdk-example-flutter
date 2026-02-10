import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:scanbot_sdk_example_flutter/ui/preview/check_preview.dart';

import '../../../utility/utils.dart';

class RtuCheckScannerFeature extends StatelessWidget {
  const RtuCheckScannerFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Scan Check'),
      onTap: () => _startCheckScanner(context),
    );
  }

  Future<void> _startCheckScanner(BuildContext context) async {
    // Always make sure you have a valid license on runtime via ScanbotSdk.getLicenseStatus()
    final isLicenseValid = await checkLicenseStatus(context);
    if (!isLicenseValid) return;

    var config = CheckScannerScreenConfiguration();
    //  Configure the strings.
    config.localization.topUserGuidance = 'Localized topUserGuidance';
    config.localization.cameraPermissionCloseButton =
        'Localized cameraPermissionCloseButton';
    config.localization.completionOverlaySuccessMessage =
        'Localized completionOverlaySuccessMessage';
    config.localization.introScreenText = 'Localized introScreenText';
    // Configure other parameters as needed.

    // An autorelease pool is required only because the result object contains image references.
    await autorelease(() async {
      var result = await ScanbotSdk.check.startScanner(config);
      switch (result) {
        case Ok():

          /// if you want to use image later, call encodeImages() to save in buffer
          //  result.data?.encodeImages();

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CheckDocumentResultPreview(uiResult: result.value),
            ),
          );
        case Error():
          await showAlertDialog(context, title: "Error", result.error.message);
        case Cancel():
          print("Operation was canceled");
      }
    });
  }
}
