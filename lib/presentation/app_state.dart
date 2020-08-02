import 'package:doncube/domain/app_setting/app_setting_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  factory AppState({
    @required ThemeMode themeMode,
  }) = _AppState;
}

class AppStateController extends StateNotifier<AppState> with LocatorMixin {
  AppStateController() : super(AppState(themeMode: ThemeMode.system));
  AppSettingService get _appSettingService => read();

  @override
  void initState() {
    state = state.copyWith(themeMode: _appSettingService.getThemeMode());
  }

  void updateThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
    _appSettingService.setThemeMode(themeMode);
  }
}
