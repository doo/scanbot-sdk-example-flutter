import 'dart:io';

import 'package:flutter/material.dart';

class PageWidget extends StatelessWidget {
  final Uri path;

  PageWidget(this.path);

  @override
  Widget build(BuildContext context) {
    // workaround - see https://github.com/flutter/flutter/issues/17419
    var file = File.fromUri(path);
    var bytes = file.readAsBytesSync();
    //
    // var image = Image.file(
    //    file,
    //   height: double.infinity,
    //    width: double.infinity,
    // );
    Image image = Image.memory(bytes);
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(child: image),
    );
  }
}
