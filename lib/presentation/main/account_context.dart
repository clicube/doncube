import 'package:doncube/data/account/account.dart';
import 'package:doncube/presentation/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AccountContext extends StatelessWidget {
  const AccountContext({
    @required this.account,
    @required this.child,
    Key key,
  }) : super(key: key);
  const AccountContext.mainPage(this.account) : child = const MainPage();
  final Account account;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Provider<Account>(
      create: (context) => account,
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
