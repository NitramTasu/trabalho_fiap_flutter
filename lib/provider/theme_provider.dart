import 'package:flutter/material.dart';

enum ThemeType { light, dark }

class ThemeProvider extends ChangeNotifier {
  final ThemeData _lightTheme =
      ThemeData.light().copyWith(primaryColor: Colors.black);
  final ThemeData _darkTheme = ThemeData.dark()
      .copyWith(primaryColor: Colors.blue, brightness: Brightness.dark);

  ThemeType currentThemeType = ThemeType.light;

  ThemeData get currentTheme {
    return currentThemeType == ThemeType.dark ? _darkTheme : _lightTheme;
  }

  void changeTheme(ThemeType type) {
    currentThemeType = type;
    notifyListeners();
  }
}
