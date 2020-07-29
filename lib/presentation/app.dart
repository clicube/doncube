import 'package:doncube/data/oauth_app/oauth_app_store.dart';
import 'package:doncube/data/session/session_store.dart';
import 'package:doncube/domain/session/session_service.dart';
import 'package:doncube/presentation/main/session_context.dart';
import 'package:doncube/presentation/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class DoncubeApp extends StatelessWidget {
  DoncubeApp({Key key}) : super(key: key) {
    timeago.setLocaleMessages('ja', timeago.JaMessages());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      initialData: null,
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _MainApp(sharedPrefs: snapshot.data);
        } else {
          return const _SplashApp();
        }
      },
    );
  }
}

class _SplashApp extends StatelessWidget {
  const _SplashApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Doncube',
      home: Scaffold(),
    );
  }
}

class _MainApp extends StatelessWidget {
  const _MainApp({@required this.sharedPrefs, Key key}) : super(key: key);
  final SharedPreferences sharedPrefs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _buildProviders(sharedPrefs),
      builder: (context, child) {
        final sessionService = context.watch<SessionService>();
        return MaterialApp(
          title: 'Doncube',
          theme: _buildTheme(context),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ja', ''),
          ],
          home: sessionService.isStoredAnySession()
              ? SessionContext.mainPage(sessionService.getSessions().first)
              : const WelcomePage(),
        );
      },
    );
  }

  ThemeData _buildTheme(BuildContext context) {
    final base = ThemeData.light();
    return base;
  }

  List<SingleChildWidget> _buildProviders(SharedPreferences sharedPrefs) {
    return [
      Provider(
        create: (context) {
          final oAuthAppStore = OAuthAppStore(sharedPrefs);
          final sessionStore = SessionStore(sharedPrefs);
          final sessionService = SessionService(
            oAuthAppStore: oAuthAppStore,
            sessionStore: sessionStore,
          );
          return sessionService;
        },
      ),
    ];
  }
}
