import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'account.dart';

class AccountStore {
  const AccountStore(this.sharedPrefs);
  static const storeKey = 'accounts';
  final SharedPreferences sharedPrefs;

  List<Account> getAll() {
    final jsonString = sharedPrefs.getString(storeKey);
    if (jsonString == null) {
      return [];
    }

    final decoded = jsonDecode(jsonString) as List<dynamic>;
    final list = decoded
        .map<Account>(
            (dynamic e) => Account.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  Future<void> save(Account account) async {
    final list = getAll();
    final idx = list.indexWhere((e) => e.uuid == account.uuid);
    if (idx > 0) {
      list[idx] = account;
    } else {
      list.add(account);
    }
    final converted = list.map((e) => e.toJson()).toList();
    final newJsonString = jsonEncode(converted);
    await sharedPrefs.setString(storeKey, newJsonString);
  }

  Future<void> remove(Account account) async {
    final list = getAll()..removeWhere((e) => e.uuid == account.uuid);
    final converted = list.map((e) => e.toJson()).toList();
    final newJsonString = jsonEncode(converted);
    await sharedPrefs.setString(storeKey, newJsonString);
  }
}
