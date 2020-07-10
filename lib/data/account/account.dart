import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Account {
  Account({
    @required this.uuid,
    @required this.instanceHostName,
    @required this.token,
  });
  Account.create({
    @required this.instanceHostName,
    @required this.token,
  }) : uuid = Uuid().v1();
  factory Account.fromJson(Map<String, dynamic> json) => _fromJson(json);
  final String uuid;
  final String instanceHostName;
  final String token;

  Map<String, dynamic> toJson() {
    return <String, String>{
      'uuid': uuid,
      'instanceHostName': instanceHostName,
      'token': token,
    };
  }

  // ignore: prefer_constructors_over_static_methods
  static Account _fromJson(Map<String, dynamic> json) {
    return Account(
      uuid: json['uuid'] as String,
      instanceHostName: json['instanceHostName'] as String,
      token: json['token'] as String,
    );
  }
}
