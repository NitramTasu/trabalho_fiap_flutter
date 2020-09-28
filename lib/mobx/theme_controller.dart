import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'theme_controller.g.dart';

enum ThemeType { light, dark }

class ThemeController = _ThemeBase with _$ThemeController;

abstract class _ThemeBase with Store {
  final ThemeData _lightTheme =
      ThemeData.light().copyWith(primaryColor: Colors.black);
  final ThemeData _darkTheme = ThemeData.dark()
      .copyWith(primaryColor: Colors.blue, brightness: Brightness.dark);

  @observable
  ThemeType currentThemeType = ThemeType.light;

  @computed
  ThemeData get currentTheme {
    return currentThemeType == ThemeType.dark ? _darkTheme : _lightTheme;
  }

  @action
  void changeTheme(ThemeType type) {
    currentThemeType = type;
  }
}
