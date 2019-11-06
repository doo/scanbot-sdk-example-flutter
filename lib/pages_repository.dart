import 'package:scanbot_sdk/common_data.dart';

class PageRepository {
  List<Page> _pages = List<Page>();

  List<Page> get pages => _pages.toList();

  removePage(Page pageToRemove) {
    _pages.remove(pageToRemove);
  }

  addPages(List<Page> newPages) {
    _pages.addAll(newPages);
  }

  clearPages() {
    _pages.clear();
  }

  Page updatePage(Page page) {
    _pages.removeWhere((e) => page.pageId == e.pageId);
    _pages.add(page);
    return page;
  }

  addPage(Page page) {
    _pages.add(page);
  }
}
