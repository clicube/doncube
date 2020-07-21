import 'dart:convert';

import 'package:doncube/data/session/session.dart';
import 'package:doncube/data/session/session_store.dart';
import 'package:doncube/data/oauth_app/oauth_app.dart';
import 'package:doncube/data/oauth_app/oauth_app_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mastodon_dart/mastodon_dart.dart';

class SessionService {
  const SessionService({
    @required this.oAuthAppStore,
    @required this.sessionStore,
  });
  final OAuthAppStore oAuthAppStore;
  final SessionStore sessionStore;
  static const appScheme = 'jp.cubik.doncube';
  static const redirectUri = '$appScheme://callback';

  Future<Session> signIn(String instanceHostName) async {
    final baseUri = Uri.parse('https://$instanceHostName');
    final mastodon = Mastodon(baseUri);

    final oAuthApp = oAuthAppStore.find(instanceHostName) ??
        await _registerOAuthApp(mastodon, instanceHostName, redirectUri);

    print('client_id: ${oAuthApp.clientId}');
    print('client_secret: ${oAuthApp.clientSecret}');

    const scopes = ['read', 'write', 'follow', 'push'];
    final authUri = mastodon.authorizationUrl.replace(
      queryParameters: <String, String>{
        'response_type': 'code',
        'client_id': oAuthApp.clientId,
        'redirect_uri': redirectUri,
        'scope': scopes.join(' '),
        'force_login': 'true',
      },
    );
    print('authentication uri: ${authUri.toString()}');

    final resultUriString = await FlutterWebAuth.authenticate(
        url: authUri.toString(), callbackUrlScheme: appScheme);
    print('callback uri: $resultUriString');

    final resultUri = Uri.parse(resultUriString);

    final response = await http.post(mastodon.tokenUrl, body: {
      'client_id': oAuthApp.clientId,
      'client_secret': oAuthApp.clientSecret,
      'redirect_uri': redirectUri,
      'grant_type': 'authorization_code',
      'code': resultUri.queryParameters['code'],
    });

    print('token response: ${response.body}');
    final accessToken = jsonDecode(response.body)['access_token'] as String;

    print('accessToken: $accessToken');

    final session = Session.create(
      instanceHostName: instanceHostName,
      token: accessToken,
    );

    await sessionStore.save(session);

    return session;
  }

  List<Session> getSessions() => sessionStore.getAll();

  bool isStoredAnySession() => sessionStore.getAll().isNotEmpty;

  Future<void> signOut(Session session) async {
    // TODO(clicube): should revoke token
    await sessionStore.remove(session);
  }

  Future<OAuthApp> _registerOAuthApp(
      Mastodon mastodon, String instanceHostName, String redirectUri) async {
    print('attempt to register new OAuth application');
    final credentials = await mastodon.appCredentials(
        Uri.parse('https://doncube.cubik.jp'), redirectUri, 'Doncube');
    final oAuthApp = OAuthApp(
      clientId: credentials.clientId,
      clientSecret: credentials.clientSecret,
      vapidKey: credentials.vapid_key,
    );
    await oAuthAppStore.save(instanceHostName, oAuthApp);
    return oAuthApp;
  }
}
