import 'package:shared_preferences/shared_preferences.dart';

const prefKey = 'isDarkOn';

class ThemeChangeRepository {
  static bool isDarkOn = false;

  Future<void> setTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefKey, isDark);
    isDarkOn = isDark;
  }

  Future<void> getIsDarkOn() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkOn = prefs.getBool(prefKey) ?? true;
  }
}
