import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';
import 'package:scanbot_sdk_example_flutter/ui/preview/credit_card_preview.dart';

import '../../../utility/utils.dart';

class RtuCreditCardScannerFeature extends StatelessWidget {
  const RtuCreditCardScannerFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Scan Credit Card'),
      onTap: () => _startCreditCardScanner(context),
    );
  }

  Future<void> _startCreditCardScanner(BuildContext context) async {
    // Always make sure you have a valid license on runtime via ScanbotSdk.getLicenseStatus()
    final isLicenseValid = await checkLicenseStatus(context);
    if (!isLicenseValid) return;

    try {
      var config = CreditCardScannerScreenConfiguration();
      // Configure the top bar mode
      config.topBar.mode = TopBarMode.GRADIENT;
      // Configure the top bar status bar mode
      config.topBar.statusBarMode = StatusBarMode.LIGHT;
      // Configure the top bar background color
      config.topBar.cancelButton.text = 'Cancel';
      // Configure parameters as needed.

      // An autorelease pool is required only because the result object contains image references.
      await autorelease(() async {
        var result = await ScanbotSdkUiV2.startCreditCardScanner(config);

        if (result.status == OperationStatus.OK && result.data?.creditCard != null) {

          /// if you want to use image later, call encodeImages() to save in buffer
          //  result.data?.encodeImages();

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreditCardResultPreview(
                uiResult: result.data,
              ),

            ),
          );
        }
      });
    } catch (e) {
      showAlertDialog(context, 'Error: ${e.toString()}');
    }
  }
}
