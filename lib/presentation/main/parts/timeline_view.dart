import 'package:doncube/data/session/session.dart';
import 'package:doncube/domain/timeline/timeline_service.dart';
import 'package:doncube/presentation/main/parts/status_widget.dart';
import 'package:doncube/presentation/main/parts/timeline_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({@required this.session, Key key}) : super(key: key);
  final Session session;

  @override
  Widget build(BuildContext context) {
    return StateNotifierProvider<TimelineStateNotifier, TimelineState>(
      create: (context) => TimelineStateNotifier(
        mastodonService: MastodonService.instance(session),
      ),
      child: const _TimelineView(),
    );
  }
}

class _TimelineView extends StatelessWidget {
  const _TimelineView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PeriodicNotifier(const Duration(seconds: 10)),
      child: RefreshIndicator(
        onRefresh: context.watch<TimelineStateNotifier>().handlePullToRefresh,
        child: Scrollbar(
          controller: PrimaryScrollController.of(context),
          child: NotificationListener<ScrollNotification>(
            onNotification:
                context.watch<TimelineStateNotifier>().handleScrollNotification,
            child: ListView(
              children: context
                  .select<TimelineState, List<TimelineElement>>(
                      (n) => n.timeline)
                  .map((e) {
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
      ),
    );
  }
}
