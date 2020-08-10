import 'dart:io';

import 'package:doncube/data/session/session.dart';
import 'package:doncube/domain/session/session_service.dart';
import 'package:doncube/presentation/app_state.dart';
import 'package:doncube/presentation/main/parts/timeline_view.dart';
import 'package:doncube/presentation/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => _PlatformTabControllerWrapper(),
      builder: (context, child) => PlatformTabScaffold(
        appBarBuilder: (context, index) => PlatformAppBar(
          title: Text('Main Page($index)'),
        ),
        tabController:
            context.watch<_PlatformTabControllerWrapper>().controller,
        bodyBuilder: (context, index) =>
            SafeArea(child: TimelineView(session: context.watch<Session>())),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(icon: Icon(Icons.build), title: Text('AAA')),
        ],
        material: (context, target) => MaterialTabScaffoldData(
          drawer: _buildDrawer(context),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const _ThemeModeToggleItem(),
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

class _ThemeModeToggleItem extends StatelessWidget {
  const _ThemeModeToggleItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDebug = false;
    assert(isDebug = true);
    if (Platform.isIOS && !isDebug) {
      return const SizedBox(width: 0, height: 0);
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text(
              'Theme mode',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            const Expanded(child: SizedBox()),
            const _ThemeModeToggleButtons(),
          ],
        ),
      );
    }
  }
}

class _ThemeModeToggleButtonModel {
  const _ThemeModeToggleButtonModel({
    @required this.label,
    @required this.themeMode,
  });
  final String label;
  final ThemeMode themeMode;
}

class _ThemeModeToggleButtons extends StatelessWidget {
  const _ThemeModeToggleButtons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const models = [
      _ThemeModeToggleButtonModel(label: 'System', themeMode: ThemeMode.system),
      _ThemeModeToggleButtonModel(label: 'Light', themeMode: ThemeMode.light),
      _ThemeModeToggleButtonModel(label: 'Dark', themeMode: ThemeMode.dark),
    ];
    final themeMode = context.select<AppState, ThemeMode>((s) => s.themeMode);
    return ToggleButtons(
      children: models.map((m) => Text(m.label)).toList(),
      isSelected: models.map((m) => themeMode == m.themeMode).toList(),
      onPressed: (index) {
        context
            .read<AppStateController>()
            .updateThemeMode(models[index].themeMode);
      },
      constraints: const BoxConstraints(minHeight: 32, minWidth: 52),
      textStyle: Theme.of(context).textTheme.overline,
    );
  }
}

class _PlatformTabControllerWrapper {
  _PlatformTabControllerWrapper();
  final PlatformTabController controller = PlatformTabController();
}
