import 'package:doncube/data/session/session_store.dart';
import 'package:doncube/data/oauth_app/oauth_app_store.dart';
import 'package:doncube/domain/session/session_service.dart';
import 'package:doncube/domain/timeline/timeline_service.dart';
import 'package:doncube/presentation/main/session_context.dart';
import 'package:doncube/presentation/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
          return Container(color: Colors.white);
        }
      },
    );
  }

  Widget _buildChild(SharedPreferences sharedPrefs) {
    return MultiProvider(
      providers: [
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
        Provider(
          create: (context) => TimelineServiceManager(),
        )
      ],
      builder: (context, child) => MaterialApp(
        title: 'Doncube',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ja', ''),
        ],
        theme: _createTheme(context),
        home: Consumer<SessionService>(
          builder: (context, sessionService, child) =>
              sessionService.isStoredAnySession()
                  ? SessionContext.mainPage(sessionService.getSessions().first)
                  : const WelcomePage(),
        ),
      ),
    );
  }
}

ThemeData _createTheme(BuildContext context) {
  final base = ThemeData.light();
  return base;
}
