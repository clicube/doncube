import 'dart:async';

import 'package:doncube/data/session/session.dart';
import 'package:doncube/domain/base/session_wired_service.dart';
import 'package:mastodon_dart/mastodon_dart.dart';

class TimelineServiceManager
    extends SessionWiredServiceManager<TimelineService> {
  @override
  TimelineService createService(Session session) =>
      TimelineService(session)..update();
}

class TimelineService implements SessionWiredService {
  TimelineService(Session session)
      : _session = session,
        _timelineController = StreamController();
  final Session _session;
  final StreamController<List<TimelineElement>> _timelineController;
  Stream<List<TimelineElement>> get timeline => _timelineController.stream;

  final List<TimelineElement> _cache = [];

  Future<void> update() async {
    final list =
        await _session.mastodon.timeline(limit: 40).catchError((Object error) {
      _timelineController.sink.addError(error);
    });
    if (list != null) {
      _cache
        ..clear()
        ..addAll(list.map((e) => StatusElement(e)));
      _timelineController.sink.add(_cache);
    }
  }

  Future<void> loadMore() async {
    if (_cache.last is GapElement) {
      return;
    }
    _cache.add(const GapElement(isLoading: true));
    _timelineController.sink.add(_cache);

    final list = await _session.mastodon
        .timeline(limit: 40, maxId: lastStatus.id)
        .catchError((Object error) {
      _timelineController.sink.addError(error);
      if (_cache.last is GapElement) {
        _cache.removeLast();
      }
    });
    if (list != null) {
      if (_cache.last is GapElement) {
        _cache.removeLast();
      }
      _cache.addAll(list.map((e) => StatusElement(e)));
      _timelineController.sink.add(_cache);
    }
  }

  Status get lastStatus =>
      (_cache.lastWhere((e) => e is StatusElement) as StatusElement).status;
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
