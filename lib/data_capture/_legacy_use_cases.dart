import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:scanbot_sdk/scanbot_sdk_ui.dart';

import '../ui/menu_item_widget.dart';
import '../ui/preview/check_preview.dart';
import '../ui/preview/ehic_preview.dart';
import '../ui/preview/medical_certificate_preview.dart';
import '../ui/preview/vin_preview.dart';
import '../utility/utils.dart';

class LegacyDataCaptureUseCases extends StatelessWidget {
  const LegacyDataCaptureUseCases({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleItemWidget(title: 'Legacy Data Detectors'),
        MenuItemWidget(
            title: "Scan EHIC (European Health Insurance Card)",
            onTap: () => startEhicScanner(context)),
        MenuItemWidget(
            title: "Scan VIN", onTap: () => startVINScanner(context)),
        MenuItemWidget(
            title: "Scan Check", onTap: () => startCheckScanner(context)),
        MenuItemWidget(
            title: "Scan Medical Certificate",
            onTap: () => startMedicalCertificateScanner(context)),

      ],
    );
  }

  Future<void> startDetector<T>({
    required BuildContext context,
    required Future<T> Function() scannerFunction,
    required Future<void> Function(BuildContext, T result) handleResult,
  }) async {
    if (!await checkLicenseStatus(context)) return;

    try {
      final result = await scannerFunction();
      await handleResult(context, result);
    } catch (e) {
      Logger.root.severe(e);
    }
  }

  Future<void> startVINScanner(BuildContext context) async {
    var configuration = VinScannerScreenConfiguration();
    configuration.topBarBackgroundColor = ScanbotRedColor;
    configuration.topBarButtonsActiveColor = Colors.white;
    // Configure other parameters as needed.

    await startDetector<ResultWrapper<VinScannerResult>>(
      context: context,
      scannerFunction: () => ScanbotSdkUi.startVinScanner(configuration),
      handleResult: (context, result) async {
        if (result.status == OperationStatus.OK) {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => VinScannerResultPreview(scanningResult: result.data!)),
          );
        } else {
          await showAlertDialog(
              context, "Operation Status: ${result.status.name}");
        }
      },
    );
  }

  Future<void> startCheckScanner(BuildContext context) async {
    var configuration = CheckScannerScreenConfiguration();
    configuration.topBarBackgroundColor = ScanbotRedColor;
    configuration.topBarButtonsActiveColor = Colors.white;
    // Configure other parameters as needed.

    await startDetector<ResultWrapper<CheckScanningResult>>(
      context: context,
      scannerFunction: () => _runCheckScanner(configuration),
      handleResult: (context, result) async {
        if (result.status == OperationStatus.OK) {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => CheckDocumentResultPreview(scanningResult: result.data!)),
          );
        } else {
          await showAlertDialog(
              context, "Operation Status: ${result.status.name}");
        }
      },
    );
  }

  Future<ResultWrapper<CheckScanningResult>> _runCheckScanner(
      CheckScannerScreenConfiguration configuration) async {
    /// You must use autorelease for result object
    /// otherwise you'll get exception "AutoReleasable objects must be created within autorelease"

    return await autorelease(() async {
      var checkScanningResult = await ScanbotSdkUi.startCheckScanner(configuration);
      /// if you want to use image later, call encodeImages() to save in buffer
      //  checkScanningResult.data?.encodeImages();
      return checkScanningResult;
    });
  }

  Future<void> startMedicalCertificateScanner(BuildContext context) async {
    var configuration = MedicalCertificateScannerConfiguration();
    configuration.returnCroppedDocumentImage = false;
    configuration.topBarBackgroundColor = ScanbotRedColor;
    configuration.topBarButtonsActiveColor = Colors.white;
    // Configure other parameters as needed.

    await startDetector<ResultWrapper<MedicalCertificateScanningResult>>(
      context: context,
      scannerFunction: () =>
          ScanbotSdkUi.startMedicalCertificateScanner(configuration),
      handleResult: (context, result) async {
        if (result.status == OperationStatus.OK) {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    MedicalCertificatePreviewWidget(result.data!)),
          );
        } else {
          await showAlertDialog(
              context, "Operation Status: ${result.status.name}");
        }
      },
    );
  }

  Future<void> startEhicScanner(BuildContext context) async {
    var configuration = HealthInsuranceCardScannerConfiguration();
    // Configure parameters as needed.

    await startDetector<
        ResultWrapper<EuropeanHealthInsuranceCardRecognitionResult>>(
      context: context,
      scannerFunction: () => ScanbotSdkUi.startEhicScanner(configuration),
      handleResult: (context, result) async {
        if (result.status == OperationStatus.OK) {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    EuropeanHealthInsuranceCardResultPreview(result.data!)),
          );
        } else {
          await showAlertDialog(
              context, "Operation Status: ${result.status.name}");
        }
      },
    );
  }
}
