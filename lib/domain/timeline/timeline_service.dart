import 'dart:async';
import 'dart:developer';

import 'package:doncube/data/session/session.dart';
import 'package:doncube/domain/base/session_wired_service.dart';
import 'package:mastodon_dart/mastodon_dart.dart';

class MastodonService implements SessionWiredService {
  factory MastodonService.instance(Session session) =>
      _getOrCreateInstance(session);
  MastodonService._(Session session) : _session = session;
  static final _instances = <String, MastodonService>{};
  final Session _session;
  List<TimelineFragment> _homeTimelineCache = [];
  final _homeTimelineController = StreamController<List<TimelineFragment>>();
  Stream<List<TimelineFragment>> get homeTimeline =>
      _homeTimelineController.stream;

  // ignore: prefer_constructors_over_static_methods
  static MastodonService _getOrCreateInstance(Session session) {
    if (_instances.containsKey(session.uuid)) {
      return _instances[session.uuid];
    } else {
      final service = MastodonService._(session);
      _instances[session.uuid] = service;
      return service;
    }
  }

  Future<void> loadHomeTimeline() async {
    final list = await _session.mastodon.timeline(limit: 40);
    _homeTimelineCache = [TimelineFragment(list)];
    _homeTimelineController.sink.add(_homeTimelineCache);
  }

  Future<void> loadLatestHomeTimeline() async {
    final result = _homeTimelineCache.toList();
    final list = await _session.mastodon.timeline(limit: 40);
    if (result.isEmpty) {
      result.add(TimelineFragment(list));
    } else {
      final merged =
          _mergeTimelineFragment(TimelineFragment(list), result.first);
      if (merged != null) {
        result[0] = merged;
      } else {
        result.insert(0, TimelineFragment(list));
      }
    }
    _homeTimelineCache = result;
    _homeTimelineController.sink.add(_homeTimelineCache);
  }

  Future<void> loadOlderHomeTimeline(TimelineFragment targetFragment) async {
    final cache = _homeTimelineCache.toList();
    final targetFragmentIndex = cache.indexOf(targetFragment);
    if (targetFragmentIndex < 0) {
      return;
    }
    final list = await _session.mastodon.timeline(
      limit: 40,
      maxId: targetFragment.list.last.id,
    );
    final newFragment = TimelineFragment([...targetFragment.list, ...list]);
    cache[targetFragmentIndex] = newFragment;
    if (cache.length > targetFragmentIndex + 1) {
      final mergedFragment =
          _mergeTimelineFragment(newFragment, cache[targetFragmentIndex + 1]);
      if (mergedFragment != null) {
        cache[targetFragmentIndex] = mergedFragment;
        cache.removeAt(targetFragmentIndex + 1);
      }
    }
    _homeTimelineCache = cache;
    _homeTimelineController.sink.add(_homeTimelineCache);
  }

  TimelineFragment _mergeTimelineFragment(
    TimelineFragment a,
    TimelineFragment b,
  ) {
    final targetId = a.list.last.id;
    final foundIndex = b.list.indexWhere((s) => s.id == targetId);
    if (foundIndex < 0) {
      return null;
    }
    final subList = b.list.sublist(foundIndex + 1);
    final marged = a.list.toList()..addAll(subList);
    return TimelineFragment(marged);
  }

//
//  TimelineService(Session session)
//      : _session = session,
//        _timelineController = StreamController();
//  final Session _session;
//  final StreamController<List<TimelineElement>> _timelineController;
//  Stream<List<TimelineElement>> get timeline => _timelineController.stream;
//
//  final List<TimelineElement> _cache = [];
//
//  Future<void> update() async {
//    final list =
//        await _session.mastodon.timeline(limit: 40).catchError((Object error) {
//      _timelineController.sink.addError(error);
//    });
//    if (list != null) {
//      _cache
//        ..clear()
//        ..addAll(list.map((e) => StatusElement(e)));
//      _timelineController.sink.add(_cache);
//    }
//  }
//
//  Future<void> loadMore() async {
//    if (_cache.last is GapElement) {
//      return;
//    }
//    _cache.add(const GapElement(isLoading: true));
//    _timelineController.sink.add(_cache);
//
//    final list = await _session.mastodon
//        .timeline(limit: 40, maxId: lastStatus.id)
//        .catchError((Object error) {
//      _timelineController.sink.addError(error);
//      if (_cache.last is GapElement) {
//        _cache.removeLast();
//      }
//    });
//    if (list != null) {
//      if (_cache.last is GapElement) {
//        _cache.removeLast();
//      }
//      _cache.addAll(list.map((e) => StatusElement(e)));
//      _timelineController.sink.add(_cache);
//    }
//  }
//
//  Status get lastStatus =>
//      (_cache.lastWhere((e) => e is StatusElement) as StatusElement).status;
}

class TimelineFragment {
  const TimelineFragment(this.list);
  final List<Status> list;
}
