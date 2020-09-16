import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/const.dart';

enum Browser { internal, external }

const Browser _defaultBrowser = Browser.internal;

/// Choose a browser for viewing story items
class BrowserProvider with ChangeNotifier {
  Browser _browser = Browser.internal;

  BrowserProvider() {
    init();
  }

  Browser get browser => _browser;

  set browser(Browser browser) {
    _browser = browser;
    notifyListeners();
  }

  /// Load chosen browser information from local storage
  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      browser = Browser.values[prefs.getInt(Const.prefBrowserKey)];
    } catch (e) {
      prefs.setInt(Const.prefBrowserKey, Browser.values.indexOf(_defaultBrowser));
    }

    notifyListeners();
  }
}
