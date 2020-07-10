import 'package:doncube/data/account/account.dart';
import 'package:doncube/domain/account/account_service.dart';
import 'package:doncube/presentation/signin/signin_page.dart';
import 'package:doncube/presentation/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = context.watch<Account>().token;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Access token: $token'),
            const SizedBox(height: 48),
            RaisedButton(
              onPressed: () => _signOut(context),
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final account = context.read<Account>();
    await context.read<AccountService>().signOut(account);
    final nextRoute =
        MaterialPageRoute<Object>(builder: (context) => const WelcomePage());
    await Navigator.of(context, rootNavigator: true)
        .pushAndRemoveUntil(nextRoute, (route) => false);
  }
}
