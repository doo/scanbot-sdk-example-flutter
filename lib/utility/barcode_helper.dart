import 'package:scanbot_sdk/json/common_data.dart';

class BarcodeHelper {
  static final barcodeFormatEnumMap = {
    BarcodeFormat.AZTEC: 'AZTEC',
    BarcodeFormat.CODABAR: 'CODABAR',
    BarcodeFormat.CODE_39: 'CODE_39',
    BarcodeFormat.CODE_93: 'CODE_93',
    BarcodeFormat.CODE_128: 'CODE_128',
    BarcodeFormat.DATA_MATRIX: 'DATA_MATRIX',
    BarcodeFormat.EAN_8: 'EAN_8',
    BarcodeFormat.EAN_13: 'EAN_13',
    BarcodeFormat.ITF: 'ITF',
    BarcodeFormat.PDF_417: 'PDF_417',
    BarcodeFormat.QR_CODE: 'QR_CODE',
    BarcodeFormat.RSS_14: 'RSS_14',
    BarcodeFormat.RSS_EXPANDED: 'RSS_EXPANDED',
    BarcodeFormat.UPC_A: 'UPC_A',
    BarcodeFormat.UPC_E: 'UPC_E',
    BarcodeFormat.MSI_PLESSEY: 'MSI_PLESSEY',
    BarcodeFormat.IATA_2_OF_5: 'IATA_2_OF_5',
    BarcodeFormat.INDUSTRIAL_2_OF_5: 'INDUSTRIAL_2_OF_5',
    BarcodeFormat.CODE_25: 'CODE_25',
    BarcodeFormat.UNKNOWN: 'UNKNOWN',
  };
}