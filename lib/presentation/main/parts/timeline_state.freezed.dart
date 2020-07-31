// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'timeline_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$TimelineStateTearOff {
  const _$TimelineStateTearOff();

// ignore: unused_element
  _TimelineState call({@required List<TimelineElement> timeline}) {
    return _TimelineState(
      timeline: timeline,
    );
  }
}

// ignore: unused_element
const $TimelineState = _$TimelineStateTearOff();

mixin _$TimelineState {
  List<TimelineElement> get timeline;

  $TimelineStateCopyWith<TimelineState> get copyWith;
}

abstract class $TimelineStateCopyWith<$Res> {
  factory $TimelineStateCopyWith(
          TimelineState value, $Res Function(TimelineState) then) =
      _$TimelineStateCopyWithImpl<$Res>;
  $Res call({List<TimelineElement> timeline});
}

class _$TimelineStateCopyWithImpl<$Res>
    implements $TimelineStateCopyWith<$Res> {
  _$TimelineStateCopyWithImpl(this._value, this._then);

  final TimelineState _value;
  // ignore: unused_field
  final $Res Function(TimelineState) _then;

  @override
  $Res call({
    Object timeline = freezed,
  }) {
    return _then(_value.copyWith(
      timeline: timeline == freezed
          ? _value.timeline
          : timeline as List<TimelineElement>,
    ));
  }
}

abstract class _$TimelineStateCopyWith<$Res>
    implements $TimelineStateCopyWith<$Res> {
  factory _$TimelineStateCopyWith(
          _TimelineState value, $Res Function(_TimelineState) then) =
      __$TimelineStateCopyWithImpl<$Res>;
  @override
  $Res call({List<TimelineElement> timeline});
}

class __$TimelineStateCopyWithImpl<$Res>
    extends _$TimelineStateCopyWithImpl<$Res>
    implements _$TimelineStateCopyWith<$Res> {
  __$TimelineStateCopyWithImpl(
      _TimelineState _value, $Res Function(_TimelineState) _then)
      : super(_value, (v) => _then(v as _TimelineState));

  @override
  _TimelineState get _value => super._value as _TimelineState;

  @override
  $Res call({
    Object timeline = freezed,
  }) {
    return _then(_TimelineState(
      timeline: timeline == freezed
          ? _value.timeline
          : timeline as List<TimelineElement>,
    ));
  }
}

class _$_TimelineState with DiagnosticableTreeMixin implements _TimelineState {
  _$_TimelineState({@required this.timeline}) : assert(timeline != null);

  @override
  final List<TimelineElement> timeline;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TimelineState(timeline: $timeline)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TimelineState'))
      ..add(DiagnosticsProperty('timeline', timeline));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _TimelineState &&
            (identical(other.timeline, timeline) ||
                const DeepCollectionEquality()
                    .equals(other.timeline, timeline)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(timeline);

  @override
  _$TimelineStateCopyWith<_TimelineState> get copyWith =>
      __$TimelineStateCopyWithImpl<_TimelineState>(this, _$identity);
}

abstract class _TimelineState implements TimelineState {
  factory _TimelineState({@required List<TimelineElement> timeline}) =
      _$_TimelineState;

  @override
  List<TimelineElement> get timeline;
  @override
  _$TimelineStateCopyWith<_TimelineState> get copyWith;
}
