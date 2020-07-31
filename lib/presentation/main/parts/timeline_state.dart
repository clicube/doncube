import 'package:doncube/domain/mastodon/mastodon_service.dart';
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
    _initialLoad();
  }
  final MastodonService _mastodonService;
  List<TimelineFragment> _fragmentList = [];
  List<TimelineElement> _elementList = [];

  bool _isScrolling = false;
  TimelineState _nextState;
  bool _isLoadingOlder = false;
  bool _canStartLoadOlder = true;

  Future<void> handlePullToRefresh() async {
    final timeline = await _mastodonService.loadLatestHomeTimeline();
    _updateTimeline(timeline);
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
          _onScrolledToBottom();
        }
        break;
    }
    return false;
  }

  Future<void> handleTapGap(GapElement gapElement) async {
    final timeline = state.timeline.toList();
    final targetIndex = timeline.indexOf(gapElement);
    if (targetIndex < 0) {
      return;
    }
    timeline[targetIndex] = GapElement(
      isLoading: true,
      olderFragment: gapElement.olderFragment,
      newerFragment: gapElement.newerFragment,
    );
    state = state.copyWith(timeline: timeline);
    await _mastodonService.loadOlderHomeTimeline(gapElement.newerFragment);
  }

  Future<void> _initialLoad() async {
    state = state.copyWith(timeline: [
      const GapElement(isLoading: true),
      ...state.timeline,
    ]);
    final timeline = await _mastodonService.loadHomeTimeline();
    _updateTimeline(timeline);
  }

  Future<void> _onScrolledToBottom() async {
    _isLoadingOlder = true;
    _canStartLoadOlder = false;
    state = state.copyWith(timeline: [
      ...state.timeline,
      const GapElement(isLoading: true),
    ]);
    final timeline = await _mastodonService
        .loadOlderHomeTimeline(_fragmentList.last)
        .whenComplete(() {
      _isLoadingOlder = false;
    });
    _updateTimeline(timeline);
  }

  void _updateTimeline(List<TimelineFragment> data) {
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
    TimelineFragment prevFragment;
    for (final fragment in list) {
      if (prevFragment != null) {
        result.add(GapElement(
          newerFragment: prevFragment,
          olderFragment: fragment,
        ));
      }
      for (final status in fragment.list) {
        result.add(StatusElement(status));
      }
      prevFragment = fragment;
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
  const GapElement({
    this.olderFragment,
    this.newerFragment,
    this.isLoading = false,
  });
  final TimelineFragment olderFragment;
  final TimelineFragment newerFragment;
  final bool isLoading;
}
