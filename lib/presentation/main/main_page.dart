import 'package:doncube/data/session/session.dart';
import 'package:doncube/domain/session/session_service.dart';
import 'package:doncube/presentation/main/parts/timeline_view.dart';
import 'package:doncube/presentation/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: TimelineView(session: context.watch<Session>()),
      drawer: _buildDrawer(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Sign out'),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final session = context.read<Session>();
    await context.read<SessionService>().signOut(session);
    final nextRoute =
        MaterialPageRoute<Object>(builder: (context) => const WelcomePage());
    await Navigator.of(context, rootNavigator: true)
        .pushAndRemoveUntil(nextRoute, (route) => false);
  }
}
