import 'package:doncube/data/app_setting/app_setting.dart';
import 'package:doncube/data/app_setting/app_setting_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppSettingService {
  AppSettingService({@required AppSettingStore appSettingStore})
      : _appSettingStore = appSettingStore {
    _appSetting = appSettingStore.get();
  }
  final AppSettingStore _appSettingStore;
  AppSetting _appSetting;

  ThemeMode getThemeMode() => _appSetting.themeMode;
  void setThemeMode(ThemeMode value) {
    _appSetting = AppSetting(themeMode: value);
    _appSettingStore.save(_appSetting);
  }
}
