import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

class SharedPrefs {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Admin Auth
  static Future<void> setAdminLoggedIn(bool value) async {
    if (_prefs == null) await init();
    await _prefs!.setBool('admin_logged_in', value);
  }

  static bool getAdminLoggedIn() {
    if (_prefs == null) return false;
    return _prefs!.getBool('admin_logged_in') ?? false;
  }

  static Future<void> setAdminEmail(String email) async {
    if (_prefs == null) await init();
    await _prefs!.setString('admin_email', email);
  }

  static String getAdminEmail() {
    if (_prefs == null) return '';
    return _prefs!.getString('admin_email') ?? '';
  }

  // Clear all data
  static Future<void> clearAll() async {
    if (_prefs == null) await init();
    await _prefs!.clear();
  }
}