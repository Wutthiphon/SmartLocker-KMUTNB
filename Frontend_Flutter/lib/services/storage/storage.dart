import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  Future<SharedPreferences> get prefs async {
    return await SharedPreferences.getInstance();
  }

  Future<void> saveData(String key, String value) async {
    final SharedPreferences prefs = await this.prefs;
    await prefs.setString(key, value);
  }

  Future<void> saveJsonData(String key, Map<String, dynamic> value) async {
    final SharedPreferences prefs = await this.prefs;
    String jsonString = jsonEncode(value);
    await prefs.setString(key, jsonString);
  }

  Future<String?> getData(String key) async {
    final SharedPreferences prefs = await this.prefs;
    return prefs.getString(key);
  }

  Future<Map<String, dynamic>?> getJsonData(String key) async {
    final SharedPreferences prefs = await this.prefs;
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }

  Future<void> remove(String key) async {
    final SharedPreferences prefs = await this.prefs;
    await prefs.remove(key);
  }
}
