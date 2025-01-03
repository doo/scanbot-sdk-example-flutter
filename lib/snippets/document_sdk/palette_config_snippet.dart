import 'package:scanbot_sdk/scanbot_sdk_ui_v2.dart';

DocumentScanningFlow palleteConfigurationFlowSnippet() {
  return DocumentScanningFlow()
    // The palette already has the default colors set, so you don't have to always set all the colors.
    ..palette.sbColorPrimary = ScanbotColor("#C8193C")
    ..palette.sbColorPrimaryDisabled = ScanbotColor("#F5F5F5")
    ..palette.sbColorNegative = ScanbotColor("#FF3737")
    ..palette.sbColorPositive = ScanbotColor("#4EFFB4")
    ..palette.sbColorWarning = ScanbotColor("#FFCE5C")
    ..palette.sbColorSecondary = ScanbotColor("#FFEDEE")
    ..palette.sbColorSecondaryDisabled = ScanbotColor("#F5F5F5")
    ..palette.sbColorOnPrimary = ScanbotColor("#FFFFFF")
    ..palette.sbColorOnSecondary = ScanbotColor("#C8193C")
    ..palette.sbColorSurface = ScanbotColor("#FFFFFF")
    ..palette.sbColorOutline = ScanbotColor("#EFEFEF")
    ..palette.sbColorOnSurfaceVariant = ScanbotColor("#707070")
    ..palette.sbColorOnSurface = ScanbotColor("#000000")
    ..palette.sbColorSurfaceLow = ScanbotColor("#26000000")
    ..palette.sbColorSurfaceHigh = ScanbotColor("#7A000000")
    ..palette.sbColorModalOverlay = ScanbotColor("#A3000000");
}

void runDocumentScanner() async {
  var configuration = palleteConfigurationFlowSnippet();
  var documentResult = await ScanbotSdkUiV2.startDocumentScanner(configuration);
  // Handle the document if the status is 'OK'
  if(documentResult.status == OperationStatus.OK) {
  }
}