import 'dart:convert';

import 'package:doncube/data/account/account.dart';
import 'package:doncube/data/account/account_store.dart';
import 'package:doncube/data/oauth_app/oauth_app.dart';
import 'package:doncube/data/oauth_app/oauth_app_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:mastodon_dart/mastodon_dart.dart' as mstdn;

class AccountService {
  const AccountService({
    @required this.oAuthAppStore,
    @required this.accountStore,
  });
  final OAuthAppStore oAuthAppStore;
  final AccountStore accountStore;
  static const appScheme = 'jp.cubik.doncube';
  static const redirectUri = '$appScheme://callback';

  Future<Account> signIn(String instanceHostName) async {
    final baseUri = Uri.parse('https://$instanceHostName');
    final mastodon = mstdn.Mastodon(baseUri);

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

    print('token response: ${response.statusCode}');
    print('              : ${response.body}');
    final accessToken = jsonDecode(response.body)['access_token'] as String;

    print('accessToken: $accessToken');

    final account = Account.create(
      instanceHostName: instanceHostName,
      token: accessToken,
    );

    await accountStore.save(account);

    return account;
  }

  List<Account> getAccounts() => accountStore.getAll();

  bool isStoredAnyAccount() => accountStore.getAll().isNotEmpty;

  Future<void> signOut(Account account) {
    // TODO(clicube): should revoke token
    accountStore.remove(account);
  }

  Future<OAuthApp> _registerOAuthApp(mstdn.Mastodon mastodon,
      String instanceHostName, String redirectUri) async {
    print('register new OAuth application');
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
