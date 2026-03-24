// ignore_for_file: unused_local_variable

import 'package:scanbot_sdk/scanbot_sdk.dart';

ImageInfo getImageInfo(ImageRef imageRef) {
  var imageInfo = imageRef.info();

  var width = imageInfo.width;
  var height = imageInfo.height;
  // size on disk or in memory depending on load mode
  var maxByteSize = imageInfo.maxByteSize;

  return imageInfo;
}
