import 'package:doncube/data/session/session.dart';
import 'package:doncube/domain/session/session_service.dart';
import 'package:doncube/domain/timeline/timeline_service.dart';
import 'package:doncube/presentation/main/parts/timeline_status.dart';
import 'package:doncube/presentation/welcome/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

class _Timeline extends StatelessWidget {
  const _Timeline({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final session = context.watch<Session>();
    final timelineService =
        context.watch<TimelineServiceManager>().getServiceFor(session);
    final scrollController = PrimaryScrollController.of(context);

    return ChangeNotifierProvider(
      create: (_) => PeriodicNotifier(const Duration(seconds: 10)),
      child: StreamBuilder<List<TimelineElement>>(
          stream: timelineService.timeline,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              _handleError(context);
              return Container();
            }
            if (snapshot.hasData) {
              return _buildTimeline(
                  timelineService, snapshot.data, scrollController);
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget _buildTimeline(TimelineService timelineService,
      List<TimelineElement> data, ScrollController scrollController) {
    return Provider(
      create: (context) => _TimelineScrollControllerWrapper(
        scrollController: scrollController,
        onBottom: timelineService.loadMore,
      ),
      dispose: (context, _TimelineScrollControllerWrapper wrapper) =>
          wrapper.dispose(),
      lazy: false,
      child: RefreshIndicator(
        onRefresh: timelineService.update,
        child: Scrollbar(
          controller: scrollController,
          child: ListView(
            controller: scrollController,
            children: data.map((e) {
              switch (e.runtimeType) {
                case StatusElement:
                  return StatusWidget(status: (e as StatusElement).status);
                case GapElement:
                  return Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
              }
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _handleError(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Scaffold.of(context).showSnackBar(
        const SnackBar(content: Text('Timeline load failed')),
      );
    });
  }
}

class _TimelineScrollControllerWrapper {
  _TimelineScrollControllerWrapper({
    @required this.scrollController,
    @required this.onBottom,
  }) {
    scrollController.addListener(listener);
  }
  final ScrollController scrollController;
  final Future<void> Function() onBottom;

  bool isProcessing = false;

  Future<void> listener() async {
    if (isProcessing) {
      return;
    }
    final bottomDistance =
        scrollController.position.maxScrollExtent - scrollController.offset;
    if (bottomDistance > 100) {
      return;
    }
    isProcessing = true;
    await onBottom().whenComplete(() => isProcessing = false);
  }

  void dispose() {
    scrollController.removeListener(listener);
  }
}
