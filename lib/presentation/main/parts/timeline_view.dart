import 'package:doncube/data/session/session.dart';
import 'package:doncube/domain/timeline/timeline_service.dart';
import 'package:doncube/presentation/main/parts/status_widget.dart';
import 'package:doncube/presentation/main/parts/timeline_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({@required this.session, Key key}) : super(key: key);
  final Session session;

  @override
  Widget build(BuildContext context) {
    return StateNotifierProvider<TimelineController, TimelineState>(
      create: (context) => TimelineController(
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
        onRefresh: context.watch<TimelineController>().handlePullToRefresh,
        child: Scrollbar(
          controller: PrimaryScrollController.of(context),
          child: NotificationListener<ScrollNotification>(
            onNotification:
                context.watch<TimelineController>().handleScrollNotification,
            child: ListView(
              children: context
                  .select<TimelineState, List<TimelineElement>>(
                      (n) => n.timeline)
                  .map((e) {
                switch (e.runtimeType) {
                  case StatusElement:
                    return StatusWidget(status: (e as StatusElement).status);
                  case GapElement:
                    return _TimelineGap(
                        isLoading: (e as GapElement).isLoading,
                        onTapLoad: () {
                          print("AAAAA");
                        });
                }
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _TimelineGap extends StatelessWidget {
  const _TimelineGap({
    @required this.isLoading,
    @required this.onTapLoad,
    Key key,
  }) : super(key: key);
  final bool isLoading;
  final Future<void> Function() onTapLoad;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          alignment: Alignment.center,
          child:
              isLoading ? _buildLoadingViewContent() : _buildGapViewContent(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Divider(
            height: 0,
            color: Colors.grey,
            indent: 56,
          ),
        ),
      ],
    );
  }

  Widget _buildGapViewContent() {
    return InkWell(
      onTap: onTapLoad,
      child: const SizedBox.expand(
        child: Center(child: Text('Load')),
      ),
    );
  }

  Widget _buildLoadingViewContent() {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
