import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:scanbot_sdk_example_flutter/model/model_data.dart';

class PlatformHelper {
  static const _imagePickerOldVersionChannel =
      MethodChannel('imagePicker_old_version_ios');

  static Future<ImagePickerResponse?> pickPhotosAsync() async {
    try {
      var result = await _imagePickerOldVersionChannel
          .invokeMethod('pickImagesFromPhotosApp');
      var resultData = ImagePickerResponse.fromJson(jsonDecode(result));
      return resultData;
    } catch (e) {
      return null;
    }
  }

  /// if version is less than iOS 14
  /// for Android return false always
  /// true: version is less than 14
  /// false: version is 14 or above
  static Future<bool> versionLessThanIOSFourteen() async {
    var isVersionLess = false;
    try {
      var result = await _imagePickerOldVersionChannel
          .invokeMethod('versionLessThanIOSFourteen');
      if (result.toString() == "true") {
        isVersionLess = true;
      }
    } catch (e) {
      isVersionLess = false;
    }
    return isVersionLess;
  }
}
