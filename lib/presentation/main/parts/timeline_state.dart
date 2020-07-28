import 'package:doncube/domain/timeline/timeline_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mastodon_dart/mastodon_dart.dart';
import 'package:state_notifier/state_notifier.dart';

part 'timeline_state.freezed.dart';

@freezed
abstract class TimelineState with _$TimelineState {
  factory TimelineState({
    @required List<TimelineElement> timeline,
  }) = _TimelineState;

  @late
  bool get isLoadingBottom => timeline.last is GapElement;
}

class TimelineController extends StateNotifier<TimelineState> {
  TimelineController({
    @required MastodonService mastodonService,
  })  : _mastodonService = mastodonService,
        super(TimelineState(timeline: [])) {
    _mastodonService.homeTimeline.listen(_onHomeTimelineUpdate);
    handleInitialLoad();
  }
  final MastodonService _mastodonService;
  List<TimelineFragment> _fragmentList = [];
  List<TimelineElement> _elementList = [];

  bool _isScrolling = false;
  TimelineState _nextState;
  bool _isLoadingOlder = false;
  bool _canStartLoadOlder = true;

  Future<void> handleInitialLoad() async {
    state = state.copyWith(timeline: [
      const GapElement(isLoading: true),
      ...state.timeline,
    ]);
    await _mastodonService.loadHomeTimeline();
  }

  Future<void> handlePullToRefresh() async {
    await _mastodonService.loadLatestHomeTimeline();
  }

  bool handleScrollNotification(ScrollNotification scrollNotification) {
    switch (scrollNotification.runtimeType) {
      case ScrollStartNotification:
        _isScrolling = true;
        if (_isLoadingOlder) {
          _canStartLoadOlder = false;
        }
        break;
      case ScrollEndNotification:
        _isScrolling = false;
        _canStartLoadOlder = true;
        if (_nextState != null) {
          state = _nextState;
          _nextState = null;
        }
        break;
      case ScrollUpdateNotification:
        final scrollUpdateNotification =
            scrollNotification as ScrollUpdateNotification;
        final distance = scrollUpdateNotification.metrics.maxScrollExtent -
            scrollUpdateNotification.metrics.pixels;
        print(distance);
        if (distance < 20 &&
            _isLoadingOlder == false &&
            _canStartLoadOlder == true &&
            state.timeline.isNotEmpty) {
          handleScrolledToBottom();
        }
        break;
    }
    return false;
  }

  Future<void> handleScrolledToBottom() async {
    _isLoadingOlder = true;
    _canStartLoadOlder = false;
    state = state.copyWith(timeline: [
      ...state.timeline,
      const GapElement(isLoading: true),
    ]);
    await _mastodonService
        .loadOlderHomeTimeline(_fragmentList.last)
        .whenComplete(() {
      _isLoadingOlder = false;
    });
  }

  void _onHomeTimelineUpdate(List<TimelineFragment> data) {
    _fragmentList = data;
    _elementList = _fragmentListToElementList(data);
    if (_isScrolling) {
      _nextState = state.copyWith(timeline: _elementList);
    } else {
      state = state.copyWith(timeline: _elementList);
    }
  }

  List<TimelineElement> _fragmentListToElementList(
      List<TimelineFragment> list) {
    final result = <TimelineElement>[];
    for (final fragment in list) {
      for (final status in fragment.list) {
        result.add(StatusElement(status));
      }
      if (fragment != list.last) {
        result.add(const GapElement());
      }
    }
    return result;
  }
}

class TimelineElement {
  const TimelineElement();
}

class StatusElement extends TimelineElement {
  const StatusElement(this.status);
  final Status status;
}

class GapElement extends TimelineElement {
  const GapElement({this.isLoading = false});
  final bool isLoading;
}
