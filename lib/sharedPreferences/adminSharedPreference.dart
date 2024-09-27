import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferences? _preferences;

  static Future initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  static String? getString(String key) {
    return _preferences?.getString(key);
  }
}
