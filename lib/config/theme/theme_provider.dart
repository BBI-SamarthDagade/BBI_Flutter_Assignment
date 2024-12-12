import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _key = 'isDarkMode';

  static Future<bool> getThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false; // Default to light mode
  }

  static Future<void> setThemePreference(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDarkMode);
  }
}
