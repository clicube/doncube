import 'package:doncube/data/account/account_store.dart';
import 'package:doncube/data/oauth_app/oauth_app_store.dart';
import 'package:doncube/domain/account/account_service.dart';
import 'package:doncube/presentation/main/account_context.dart';
import 'package:doncube/presentation/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoncubeApp extends StatelessWidget {
  const DoncubeApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      initialData: null,
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildChild(snapshot.data);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildChild(SharedPreferences sharedPrefs) {
//    final oAuthAppStore = OAuthAppStore(sharedPrefs);
//    final accountStore = AccountStore(sharedPrefs);
//    final accountService = AccountService(
//      oAuthAppStore: oAuthAppStore,
//      accountStore: accountStore,
//    );
    return MultiProvider(
      providers: [
//        Provider.value(value: accountService),
        Provider(
          create: (context) {
            final oAuthAppStore = OAuthAppStore(sharedPrefs);
            final accountStore = AccountStore(sharedPrefs);
            final accountService = AccountService(
              oAuthAppStore: oAuthAppStore,
              accountStore: accountStore,
            );
            return accountService;
          },
        ),
      ],
      builder: (context, child) => MaterialApp(
        title: 'Doncube',
        home: Consumer<AccountService>(
          builder: (context, accountService, child) =>
              accountService.isStoredAnyAccount()
                  ? AccountContext.mainPage(accountService.getAccounts().first)
                  : const WelcomePage(),
        ),
      ),
    );
  }
}
