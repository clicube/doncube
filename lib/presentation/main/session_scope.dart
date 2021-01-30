import 'package:doncube/data/session/session.dart';
import 'package:doncube/presentation/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SessionScope extends StatelessWidget {
  const SessionScope({
    @required this.session,
    @required this.child,
    Key key,
  }) : super(key: key);
  SessionScope.mainPage(this.session) : child = MainPage();
  final Session session;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: session,
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
