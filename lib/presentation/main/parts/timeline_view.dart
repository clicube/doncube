import 'package:doncube/data/session/session.dart';
import 'package:doncube/domain/mastodon/mastodon_service.dart';
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
            child: ListView.separated(
              itemBuilder: (context, index) => _TimelineViewListItem(index),
              itemCount:
                  context.select<TimelineState, int>((s) => s.timeline.length),
              separatorBuilder: _separator,
            ),
          ),
        ),
      ),
    );
  }

  Widget _separator(BuildContext context, int index) {
    return const Divider(
      height: 0,
      indent: 68,
      endIndent: 12,
      color: Colors.grey,
    );
  }
}

class _TimelineViewListItem extends StatelessWidget {
  const _TimelineViewListItem(this.index, {Key key}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    final element = context
        .select<TimelineState, TimelineElement>((n) => n.timeline[index]);
    switch (element.runtimeType) {
      case StatusElement:
        return StatusWidget(status: (element as StatusElement).status);
      case GapElement:
        return _TimelineGap(
            isLoading: (element as GapElement).isLoading,
            onTapLoad: () async {
              await context
                  .read<TimelineController>()
                  .loadGapNewer(element as GapElement);
            });
      default:
        return Container();
    }
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
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: isLoading ? _buildLoadingViewContent() : _buildGapViewContent(),
    );
  }

  Widget _buildGapViewContent() {
    return Material(
      color: Colors.grey[300],
      child: InkWell(
        onTap: onTapLoad,
        child: const Center(
          child: Text('Load',
              style: TextStyle(
                color: Colors.grey,
              )),
        ),
      ),
    );
  }

  Widget _buildLoadingViewContent() {
    return Container(
      color: Colors.grey[300],
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
