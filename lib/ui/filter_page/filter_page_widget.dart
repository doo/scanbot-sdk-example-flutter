import 'package:flutter/material.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart' as sdk;

import 'filter_preview_widget.dart';

class PageFiltering extends StatelessWidget {
  final sdk.Page _page;

  PageFiltering(this._page);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).pop(_page),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Back',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.black, // Change your color here
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Filtering',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FilterPreviewWidget(_page),
    );
  }
}
