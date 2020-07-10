import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'oauth_app.dart';

class OAuthAppStore {
  const OAuthAppStore(this.sharedPrefs);
  static const storeKey = 'oauthApps';
  final SharedPreferences sharedPrefs;

  OAuthApp find(String instanceHostName) {
    final jsonString = sharedPrefs.getString(storeKey);
    if (jsonString == null) {
      return null;
    }

    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    if (!decoded.keys.contains(instanceHostName)) {
      return null;
    }

    return OAuthApp.fromJson(decoded[instanceHostName] as Map<String, dynamic>);
  }

  Future<void> save(String instanceHostName, OAuthApp oAuthApp) async {
    Map<String, dynamic> map;
    final jsonString = sharedPrefs.getString(storeKey);
    if (jsonString != null) {
      map = jsonDecode(jsonString) as Map<String, dynamic>;
    } else {
      map = <String, dynamic>{};
    }
    map[instanceHostName] = oAuthApp.toJson();
    final newJsonString = jsonEncode(map);
    await sharedPrefs.setString(storeKey, newJsonString);
  }
}
