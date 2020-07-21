import 'package:flutter/foundation.dart';
import 'package:mastodon_dart/mastodon_dart.dart';
import 'package:uuid/uuid.dart';

class Session {
  Session({
    @required this.uuid,
    @required this.instanceHostName,
    @required this.token,
  }) : mastodon = _createMastodon(instanceHostName) {
    mastodon.token = token;
  }

  factory Session.create({
    @required String instanceHostName,
    @required String token,
  }) {
    return Session(
      uuid: Uuid().v1(),
      instanceHostName: instanceHostName,
      token: token,
    );
  }

  factory Session.fromJson(Map<String, dynamic> json) => _fromJson(json);

  final String uuid;
  final String instanceHostName;
  final String token;
  final Mastodon mastodon;

  Map<String, dynamic> toJson() {
    return <String, String>{
      'uuid': uuid,
      'instanceHostName': instanceHostName,
      'token': token,
    };
  }

  // ignore: prefer_constructors_over_static_methods
  static Session _fromJson(Map<String, dynamic> json) {
    return Session(
      uuid: json['uuid'] as String,
      instanceHostName: json['instanceHostName'] as String,
      token: json['token'] as String,
    );
  }

  static Mastodon _createMastodon(String instanceHostName) =>
      Mastodon(Uri.parse('https://$instanceHostName'));
}
