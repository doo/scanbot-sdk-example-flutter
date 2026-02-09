import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';

import '../../../ui/preview/mrz_document_preview.dart';
import '../../../utility/utils.dart';

class RtuMrzScannerFeature extends StatelessWidget {
  const RtuMrzScannerFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Scan MRZ'),
      onTap: () => _startMrzScanner(context),
    );
  }

  Future<void> _startMrzScanner(BuildContext context) async {
    // Always make sure you have a valid license on runtime via ScanbotSdk.getLicenseStatus()
    final isLicenseValid = await checkLicenseStatus(context);
    if (!isLicenseValid) return;

    var config = MrzScannerScreenConfiguration();

    // Set colors
    config.palette.sbColorPrimary = ScanbotColor('#C8193C');
    config.palette.sbColorOnPrimary = ScanbotColor('#ffffff');

    // Add a top guidance title
    config.topUserGuidance.title = StyledText(
      text: 'Scan MRZ',
      color: ScanbotColor('#C8193C'),
      useShadow: true,
    );

    // Modify the action bar
    config.actionBar.flipCameraButton.visible = false;
    config.actionBar.flashButton.activeForegroundColor =
        ScanbotColor('#C8193C');

    // Configure the scanner
    config.scannerConfiguration.incompleteResultHandling =
        MrzIncompleteResultHandling.ACCEPT;

    // Configure other parameters as needed.
    final result = await ScanbotSdk.mrz.startScanner(config);
    switch (result) {
      case Ok():

        // Always serialize the MRZ document before stringifying, and use the serialized result.
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MrzDocumentResultPreview(
              uiResult: result.value,
            ),
          ),
        );
      case Error():
        await showAlertDialog(context, title: "Error", result.error.message);
      case Cancel():
        print("Operation was canceled");
    }
  }
}
