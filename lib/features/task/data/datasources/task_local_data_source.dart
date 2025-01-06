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

  
  //newly added methods

  static Future<void> setSortOrder(bool ascending) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sort_order', ascending);
  }

  static Future<bool> getSortOrder() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('sort_order') ?? true; // Default to ascending
  }


}

