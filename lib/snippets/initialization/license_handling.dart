import 'package:scanbot_sdk/scanbot_sdk.dart';

Future<void> checkLicense() async {
  final licenseResult = await ScanbotSdk.getLicenseInfo();
  if (licenseResult is Ok<LicenseInfo> && licenseResult.value.isValid) {
    // Calling ScanbotSDK API is safe now.
    // ...
  } else {
    // Handle an invalid license or a failure to retrieve license info,
    // e.g. disable the scanning features and inform the user.
  }
}

Future<void> checkLicenseStatus() async {
  final result = await ScanbotSdk.getLicenseInfo();
  if (result is Ok<LicenseInfo>) {
    final licenseInfo = result.value;
    // Use licenseInfo.status, licenseInfo.isValid and
    // licenseInfo.expirationDateString, e.g. to show the license state in your app.
  } else {
    // Handle error when getting license info, e.g. show a message to the user.
  }
}

Future<void> handleLicenseStatus() async {
  final result = await ScanbotSdk.getLicenseInfo();
  if (result is! Ok<LicenseInfo>) {
    // Handle error when getting license info, e.g. show a message to the user.
    return;
  }

  final licenseInfo = result.value;
  switch (licenseInfo.status) {
    case LicenseStatus.OKAY:
      // License is valid - proceed with SDK operations.
      break;
    case LicenseStatus.OKAY_EXPIRING_SOON:
      // License will expire soon on licenseInfo.expirationDateString - notify user to renew.
      break;
    case LicenseStatus.TRIAL:
      // SDK is in trial mode - e.g. show a trial badge in your app.
      break;
    case LicenseStatus.FAILURE_EXPIRED:
      // License has expired - disable the scanning features and ask the user to renew.
      break;
    case LicenseStatus.FAILURE_APP_ID_MISMATCH:
      // License doesn't match the app bundle ID - check your license key and app ID.
      break;
    case LicenseStatus.FAILURE_NOT_SET:
      // No license set and trial has ended - set a valid license key.
      break;
    default:
      // Handle other failure cases, e.g. show licenseInfo.licenseStatusMessage
      // and licenseInfo.errorMessage to the user.
      break;
  }
}
