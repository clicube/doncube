import 'package:doncube/data/session/session.dart';
import 'package:doncube/presentation/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SessionContext extends StatelessWidget {
  const SessionContext({
    @required this.session,
    @required this.child,
    Key key,
  }) : super(key: key);
  const SessionContext.mainPage(this.session) : child = const MainPage();
  final Session session;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Provider<Session>(
      create: (context) => session,
      builder: (context, child) => _createNavigator(this.child),
    );
  }

  Widget _createNavigator(Widget child) {
    return Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute<Object>(
        builder: (context) => child,
      ),
    );
  }
}
