import 'package:doncube/data/session/session.dart';
import 'package:doncube/domain/session/session_service.dart';
import 'package:doncube/presentation/main/developer_tab.dart';
import 'package:doncube/presentation/main/parts/timeline_view.dart';
import 'package:doncube/presentation/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  MainPage({Key key}) : super(key: key);

  final tabs = <_TabData>[
    _TabData(
      title: 'Home',
      icon: const Icon(Icons.home),
      builder: (BuildContext context) => SafeArea(
        child: TimelineView(session: context.watch<Session>()),
      ),
    ),
    _TabData(
      title: 'Developer',
      icon: const Icon(Icons.build),
      builder: (BuildContext context) => const SafeArea(child: DeveloperTab()),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => _PlatformTabControllerWrapper(),
      builder: (context, child) => PlatformTabScaffold(
        appBarBuilder: (context, index) => PlatformAppBar(
          title: Text(tabs[index].title),
        ),
        tabController:
            context.watch<_PlatformTabControllerWrapper>().controller,
        bodyBuilder: (context, index) => tabs[index].builder.call(context),
        items: tabs
            .map((e) =>
                BottomNavigationBarItem(title: Text(e.title), icon: e.icon))
            .toList(),
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

class _TabData {
  _TabData({@required this.title, @required this.icon, @required this.builder});
  final String title;
  final Icon icon;
  final Widget Function(BuildContext) builder;
}

class _PlatformTabControllerWrapper {
  _PlatformTabControllerWrapper();
  final PlatformTabController controller = PlatformTabController();
}
