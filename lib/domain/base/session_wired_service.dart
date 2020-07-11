import 'package:doncube/data/session/session.dart';

abstract class SessionWiredServiceManager<T extends SessionWiredService> {
  SessionWiredServiceManager() : _services = {};
  final Map<Session, T> _services;

  T getServiceFor(Session session) {
    if (_services.containsKey(session)) {
      return _services[session];
    } else {
      final service = createService(session);
      _services[session] = service;
      return service;
    }
  }

  T createService(Session session);
}

mixin SessionWiredService {}
