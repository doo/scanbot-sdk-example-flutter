import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

import '../../../ui/preview/vin_preview.dart';
import '../../../utility/utils.dart';

class RtuVinScannerFeature extends StatelessWidget {
  const RtuVinScannerFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Scan VIN'),
      onTap: () => _startCheckScanner(context),
    );
  }

  Future<void> _startCheckScanner(BuildContext context) async {
    // Always make sure you have a valid license on runtime via ScanbotSdk.getLicenseStatus()
    final isLicenseValid = await checkLicenseStatus(context);
    if (!isLicenseValid) return;

    try {
      var config = VinScannerScreenConfiguration();
      config.introScreen.explanation.text =
          'Quickly and securely scan the VIN by holding your device over the vehicle identification number or vehicle identification barcode' +
              '\\nThe scanner will guide you to the optimal scanning position.' +
              'Once the scan is complete, your VIN details will automatically be extracted and processed.';
      // Configure the done button. E.g., the text or the background color.
      config.introScreen.doneButton.text = 'Start Scanning';
      config.introScreen.doneButton.background.fillColor = ScanbotColor('#C8193C');
      // Configure other parameters as needed.

      var result = await ScanbotSdkUiV2.startVINScanner(config);

      if (result.status == OperationStatus.OK && result.data != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VinScannerResultPreview(
              uiResult: result.data,
            ),
          ),
        );
      }
    } catch (e) {
      showAlertDialog(context, 'Error: ${e.toString()}');
    }
  }
}
