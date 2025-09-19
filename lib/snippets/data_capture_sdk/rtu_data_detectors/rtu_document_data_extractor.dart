import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

import '../../../ui/preview/extracted_document_data_preview.dart';
import '../../../utility/utils.dart';

class RtuDocumentDataExtractorFeature extends StatelessWidget {
  const RtuDocumentDataExtractorFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Scan Document Data Extractor'),
      onTap: () => _startDocumentDataExtractor(context),
    );
  }

  Future<void> _startDocumentDataExtractor(BuildContext context) async {
    // Always make sure you have a valid license on runtime via ScanbotSdk.getLicenseStatus()
    final isLicenseValid = await checkLicenseStatus(context);
    if (!isLicenseValid) return;

    try {
      var config = DocumentDataExtractorScreenConfiguration();
      config.viewFinder.overlayColor = ScanbotColor('#C8193C');
      // Configure other parameters as needed.

      // An autorelease pool is required only because the result object contains image references.
      await autorelease(() async {
        var result = await ScanbotSdkUiV2.startDocumentDataExtractor(config);

        if (result.status == OperationStatus.OK && result.data?.document != null) {

          /// if you want to use image later, call encodeImages() to save in buffer
          //  result.data?.encodeImages();

          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExtractedDocumentDataPreview(
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
