// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$AppStateTearOff {
  const _$AppStateTearOff();

// ignore: unused_element
  _AppState call({@required ThemeMode themeMode}) {
    return _AppState(
      themeMode: themeMode,
    );
  }
}

// ignore: unused_element
const $AppState = _$AppStateTearOff();

mixin _$AppState {
  ThemeMode get themeMode;

  $AppStateCopyWith<AppState> get copyWith;
}

abstract class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) then) =
      _$AppStateCopyWithImpl<$Res>;
  $Res call({ThemeMode themeMode});
}

class _$AppStateCopyWithImpl<$Res> implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  final AppState _value;
  // ignore: unused_field
  final $Res Function(AppState) _then;

  @override
  $Res call({
    Object themeMode = freezed,
  }) {
    return _then(_value.copyWith(
      themeMode:
          themeMode == freezed ? _value.themeMode : themeMode as ThemeMode,
    ));
  }
}

abstract class _$AppStateCopyWith<$Res> implements $AppStateCopyWith<$Res> {
  factory _$AppStateCopyWith(_AppState value, $Res Function(_AppState) then) =
      __$AppStateCopyWithImpl<$Res>;
  @override
  $Res call({ThemeMode themeMode});
}

class __$AppStateCopyWithImpl<$Res> extends _$AppStateCopyWithImpl<$Res>
    implements _$AppStateCopyWith<$Res> {
  __$AppStateCopyWithImpl(_AppState _value, $Res Function(_AppState) _then)
      : super(_value, (v) => _then(v as _AppState));

  @override
  _AppState get _value => super._value as _AppState;

  @override
  $Res call({
    Object themeMode = freezed,
  }) {
    return _then(_AppState(
      themeMode:
          themeMode == freezed ? _value.themeMode : themeMode as ThemeMode,
    ));
  }
}

class _$_AppState with DiagnosticableTreeMixin implements _AppState {
  _$_AppState({@required this.themeMode}) : assert(themeMode != null);

  @override
  final ThemeMode themeMode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppState(themeMode: $themeMode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppState'))
      ..add(DiagnosticsProperty('themeMode', themeMode));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AppState &&
            (identical(other.themeMode, themeMode) ||
                const DeepCollectionEquality()
                    .equals(other.themeMode, themeMode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(themeMode);

  @override
  _$AppStateCopyWith<_AppState> get copyWith =>
      __$AppStateCopyWithImpl<_AppState>(this, _$identity);
}

abstract class _AppState implements AppState {
  factory _AppState({@required ThemeMode themeMode}) = _$_AppState;

  @override
  ThemeMode get themeMode;
  @override
  _$AppStateCopyWith<_AppState> get copyWith;
}
