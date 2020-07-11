import 'package:doncube/data/session/session.dart';
import 'package:doncube/domain/session/session_service.dart';
import 'package:doncube/domain/timeline/timeline_service.dart';
import 'package:doncube/presentation/main/parts/timeline_status.dart';
import 'package:doncube/presentation/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:mastodon_dart/mastodon_dart.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: const _Timeline(),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Sign out'),
              onTap: () => _signOut(context),
            ),
          ],
        ),
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

class _Timeline extends StatelessWidget {
  const _Timeline({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final session = context.watch<Session>();
    final timelineService = context
        .watch<TimelineServiceManager>()
        .getServiceFor(session)
          ..update();

    return StreamBuilder<List<Status>>(
        stream: timelineService.timeline,
        initialData: const <Status>[],
        builder: (context, snapshot) => ListView(
              children: snapshot.data
                  .map((e) => StatusWidget(
                        status: e,
                      ))
                  .toList(),
            ));
  }
}
