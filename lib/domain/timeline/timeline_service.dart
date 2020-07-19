import 'dart:async';

import 'package:doncube/data/session/session.dart';
import 'package:doncube/domain/base/session_wired_service.dart';
import 'package:mastodon_dart/mastodon_dart.dart';

class TimelineServiceManager
    extends SessionWiredServiceManager<TimelineService> {
  @override
  TimelineService createService(Session session) => TimelineService(session);
}

class TimelineService implements SessionWiredService {
  TimelineService(this.session) : _controller = StreamController();
  final Session session;
  final StreamController<List<Status>> _controller;

  Stream<List<Status>> get timeline => _controller.stream;

  Future<void> update() async {
    final list = await session.mastodon.timeline().catchError((Object error) {
      _controller.sink.addError(error);
    });
    if (list != null) {
      _controller.sink.add(list);
    }
  }
}
