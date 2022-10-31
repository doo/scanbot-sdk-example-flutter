import 'dart:convert';

import 'package:scanbot_sdk/json/common_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageRepository {
  static final PageRepository _instance = PageRepository._internal();

  factory PageRepository() => _instance;

  PageRepository._internal() {
    // init some stuff here
  }

  final List<Page> _pages = <Page>[];

  List<Page> get pages => _pages.toList();

  Future<void> removePage(Page pageToRemove) async {
    _pages.remove(pageToRemove);
    await _storePages();
  }

  Future<void> addPages(List<Page> newPages) async {
    _pages.addAll(newPages);
    await _storePages();
  }

  Future<void> clearPages() async {
    _pages.clear();
    await _storePages();
  }

  Future<void> updatePage(Page page) async {
    _pages.removeWhere((e) => page.pageId == e.pageId);
    _pages.add(page);
    await _storePages();
  }

  Future<void> addPage(Page page) async {
    _pages.add(page);
    await _storePages();
  }

  Future<void> loadPages() async {
    final db = await _getDbInstance();
    var pagesJsonString = db.getString('pages');
    if (pagesJsonString == null) {
      return;
    }
    List<dynamic> pagesJson = jsonDecode(pagesJsonString);
    final loadedPages =
        pagesJson.map((p) => Page.fromJson(p as Map<String, dynamic>)).toList();
    _pages.clear();
    if (loadedPages.isNotEmpty) {
      var refreshPages = await ScanbotSdk.refreshImageUris(loadedPages);
      _pages.addAll(refreshPages);
    }
  }

  Future<void> _storePages() async {
    final db = await _getDbInstance();
    await db.setString('pages', jsonEncode(_pages));
  }

  Future<SharedPreferences> _getDbInstance() async {
    // TODO use a SQLite DB based storage instead of SharedPreferences
    return SharedPreferences.getInstance();
  }
}
