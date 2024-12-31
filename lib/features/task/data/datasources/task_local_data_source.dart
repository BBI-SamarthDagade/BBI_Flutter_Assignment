import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const _sortByDueDateKey = 'sortByDueDate';

  static Future<bool> getSortByDueDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sortByDueDateKey) ?? true;
  }

  static Future<void> setSortByDueDate(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sortByDueDateKey, value);
  }
}