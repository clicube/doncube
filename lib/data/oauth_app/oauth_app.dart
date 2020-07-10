import 'package:flutter/foundation.dart';

class OAuthApp {
  const OAuthApp({
    @required this.clientId,
    @required this.clientSecret,
    @required this.vapidKey,
  });
  factory OAuthApp.fromJson(Map<String, dynamic> json) => _fromJson(json);

  final String clientId;
  final String clientSecret;
  final String vapidKey;

  Map<String, dynamic> toJson() {
    return <String, String>{
      'client_id': clientId,
      'client_secret': clientSecret,
      'vapid_key': vapidKey
    };
  }

  // ignore: prefer_constructors_over_static_methods
  static OAuthApp _fromJson(Map<String, dynamic> json) {
    return OAuthApp(
      clientId: json['client_id'] as String,
      clientSecret: json['client_secret'] as String,
      vapidKey: json['vapid_key'] as String,
    );
  }
}
