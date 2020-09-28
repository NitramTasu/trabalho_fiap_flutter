// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ThemeController on _ThemeBase, Store {
  Computed<ThemeData> _$currentThemeComputed;

  @override
  ThemeData get currentTheme =>
      (_$currentThemeComputed ??= Computed<ThemeData>(() => super.currentTheme,
              name: '_ThemeBase.currentTheme'))
          .value;

  final _$currentThemeTypeAtom = Atom(name: '_ThemeBase.currentThemeType');

  @override
  ThemeType get currentThemeType {
    _$currentThemeTypeAtom.reportRead();
    return super.currentThemeType;
  }

  @override
  set currentThemeType(ThemeType value) {
    _$currentThemeTypeAtom.reportWrite(value, super.currentThemeType, () {
      super.currentThemeType = value;
    });
  }

  final _$_ThemeBaseActionController = ActionController(name: '_ThemeBase');

  @override
  void changeTheme(ThemeType type) {
    final _$actionInfo = _$_ThemeBaseActionController.startAction(
        name: '_ThemeBase.changeTheme');
    try {
      return super.changeTheme(type);
    } finally {
      _$_ThemeBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentThemeType: ${currentThemeType},
currentTheme: ${currentTheme}
    ''';
  }
}
