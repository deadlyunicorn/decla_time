import "dart:async";

import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class SettingsController extends ChangeNotifier {
  String get locale => _locale ?? "el";

  String? _locale;

  Future<void> loadSettings() async {
    final SharedPreferences sharedPreferences =
        (await SharedPreferences.getInstance());
    _locale = sharedPreferences.getString("locale") ?? "el";
    unawaited(sharedPreferences.setString("locale", _locale!));

    notifyListeners();
  }

  Future<void> toggleLocale() async {
    final SharedPreferences sharedPreferences =
        (await SharedPreferences.getInstance());
    final String storedLocale = sharedPreferences.getString("locale") ?? "el";

    if (storedLocale == "el") {
      _locale = "en";
      unawaited(sharedPreferences.setString("locale", "en"));
    } else {
      _locale = "el";
      unawaited(sharedPreferences.setString("locale", "el"));
    }

    notifyListeners();
  }
}
