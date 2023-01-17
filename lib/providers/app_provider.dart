import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

final themeMap = {
  "dark": ThemeMode.dark,
  "light": ThemeMode.light,
};

class AppProvider extends ChangeNotifier {
  static AppProvider state(BuildContext context, [bool listen = false]) =>
      Provider.of<AppProvider>(context, listen: listen);

  final _cache = Hive.box('app');

  /// Theme
  ThemeMode? _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode!;

  void init() {
    String? stringTheme = _cache.get('theme');

    ThemeMode? theme =
        stringTheme == null ? ThemeMode.light : themeMap[stringTheme];

    if (theme == null) {
      _cache.put(
        'theme',
        ThemeMode.light.toString().split(".").last,
      );
      _themeMode = ThemeMode.light;
    }
    _themeMode = theme;

    String? cachedLocale = _cache.get('lang');
    currentLocale = cachedLocale == null
        ? const Locale('en', 'US')
        : cachedLocale.contains('ar')
            ? const Locale('ar', 'SA')
            : const Locale('en', 'US');

    notifyListeners();
  }

  bool get isDark => themeMode == ThemeMode.dark;

  void setTheme(ThemeMode newTheme) {
    if (_themeMode == newTheme) {
      return;
    }
    _themeMode = newTheme;

    _cache.put(
      'theme',
      newTheme.toString().split('.').last,
    );
    notifyListeners();
  }

  /// Utils
  bool isListView = true;
  bool get view => isListView;

  void changeView() {
    isListView = !isListView;

    notifyListeners();
  }

  /// Localization
  Locale currentLocale = const Locale('en', 'US');

  Locale get language => currentLocale;

  set langauge(Locale locale) {
    currentLocale = locale;

    _cache.put('lang', locale.languageCode);

    notifyListeners();
  }

  // reordering
  bool _shouldChangeState = false;
  bool _reorderEnabled = false;

  bool get reorderable => _reorderEnabled;
  bool get shouldChangeState => _shouldChangeState;

  set shouldChangeState(bool value) {
    _shouldChangeState = value;

    notifyListeners();
  }

  set reorderable(bool value) {
    _reorderEnabled = value;

    notifyListeners();
  }
}
