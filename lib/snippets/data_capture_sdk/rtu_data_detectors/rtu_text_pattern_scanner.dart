import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

import '../../../ui/preview/text_pattern_preview.dart';
import '../../../utility/utils.dart';

class RtuTextPatternScannerFeature extends StatelessWidget {
  const RtuTextPatternScannerFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Scan Text Pattern'),
      onTap: () => _startTextPatternScanner(context),
    );
  }

  Future<void> _startTextPatternScanner(BuildContext context) async {
    // Always make sure you have a valid license on runtime via ScanbotSdk.getLicenseStatus()
    final isLicenseValid = await checkLicenseStatus(context);
    if (!isLicenseValid) return;

    try {
      var config = TextPatternScannerScreenConfiguration();
      // Show the top user guidance
      config.topUserGuidance.visible = true;
      // Customize the top user guidance
      config.topUserGuidance.title.text = 'Customized title';
      // Configure parameters as needed.

      var result = await ScanbotSdkUiV2.startTextPatternScanner(config);

      if (result.status == OperationStatus.OK && result.data != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TextPatternScannerUiResultPreview(result.data!),
          ),
        );
      }
    } catch (e) {
      showAlertDialog(context, 'Error: ${e.toString()}');
    }
  }
}
