import 'package:khanos/src/preferences/user_preferences.dart';
import 'package:flutter/material.dart';

final prefs = new UserPreferences();

var darkTheme = ThemeData.dark().copyWith(
    accentColor: Colors.lightBlue,
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.grey[900]));
var lightTheme = ThemeData.light().copyWith(
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.grey[200]));

class ThemeChanger extends ChangeNotifier {
  ThemeData _themeData;
  ThemeChanger(this._themeData);

  get getTheme {
    _themeData = (prefs.darkTheme ? darkTheme : lightTheme);
    return _themeData;
  }

  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
