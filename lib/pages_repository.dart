import 'dart:convert';

import 'package:scanbot_sdk/common_data.dart';
import 'package:scanbot_sdk/scanbot_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageRepository {

  static final PageRepository _singleton = PageRepository._internal();

  factory PageRepository() {
    return _singleton;
  }

  PageRepository._internal();

  List<Page> _pages = List<Page>();

  List<Page> get pages => _pages.toList();

  removePage(Page pageToRemove) async {
    _pages.remove(pageToRemove);
    await _storePages();
  }

  addPages(List<Page> newPages) async {
    _pages.addAll(newPages);
    await _storePages();
  }

  clearPages() async {
    _pages.clear();
    await _storePages();
  }

  updatePage(Page page) async {
    _pages.removeWhere((e) => page.pageId == e.pageId);
    _pages.add(page);
    await _storePages();
  }

  addPage(Page page) async {
    _pages.add(page);
    await _storePages();
  }

  loadPages() async {
    final db = await _getDbInstance();
    var pagesJsonString = db.getString("pages");
    if (pagesJsonString == null) {
      return;
    }
    List<dynamic> pagesJson = jsonDecode(pagesJsonString);
    List<Page> loadedPages = pagesJson?.map((p) => Page.fromJson(p as Map<String, dynamic>))?.toList();
    _pages.clear();
    if (loadedPages != null && loadedPages.isNotEmpty) {
      var refreshPages = await ScanbotSdk.refreshImageUris(loadedPages);
      _pages.addAll(refreshPages);
    }
  }

  _storePages() async {
    final db = await _getDbInstance();
    await db.setString("pages", jsonEncode(_pages));
  }

  _getDbInstance() {
    // TODO use a SQLite DB based storage instead of SharedPreferences
    return SharedPreferences.getInstance();
  }
}
