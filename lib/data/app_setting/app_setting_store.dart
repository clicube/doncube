import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_setting.dart';

class AppSettingStore {
  const AppSettingStore(this.sharedPrefs);
  static const storeKey = 'appSetting';
  final SharedPreferences sharedPrefs;

  AppSetting get() {
    final jsonString = sharedPrefs.getString(storeKey) ?? '{}';
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return AppSetting.fromJson(map);
  }

  Future<void> save(AppSetting appSetting) async {
    final jsonString = jsonEncode(appSetting.toJson());
    await sharedPrefs.setString(storeKey, jsonString);
  }
}
