import 'dart:async';

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

    final list1 = list.getRange(0, 2).toList();
    final list2 = list.getRange(5, 8).toList();

    _homeTimelineCache = [TimelineFragment(list1), TimelineFragment(list2)];
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
}

class TimelineFragment {
  const TimelineFragment(this.list);
  final List<Status> list;
}
