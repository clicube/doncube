import 'package:doncube/data/session/session.dart';
import 'package:doncube/domain/mastodon/mastodon_service.dart';
import 'package:doncube/presentation/main/parts/status_widget.dart';
import 'package:doncube/presentation/main/parts/timeline_state.dart';
import 'package:doncube/presentation/main/parts/value_listenable_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({@required this.session, Key key}) : super(key: key);
  final Session session;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StateNotifierProvider<TimelineController, TimelineState>(
          create: (context) => TimelineController(
            mastodonService: MastodonService.instance(session),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PeriodicNotifier(const Duration(seconds: 10)),
        ),
      ],
      child: const _TimelineView(),
    );
  }
}

class _TimelineView extends StatelessWidget {
  const _TimelineView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timelineController = context.watch<TimelineController>();
    return ValueListenableListener<String>(
      valueListenable: timelineController.errorNotifier,
      onChange: (message) => _showError(context, message),
      child: RefreshIndicator(
        onRefresh: timelineController.handlePullToRefresh,
        child: Scrollbar(
          controller: PrimaryScrollController.of(context),
          child: NotificationListener<ScrollNotification>(
            onNotification: timelineController.handleScrollNotification,
            child: ListView.separated(
              itemBuilder: (context, index) => _TimelineViewListItem(index),
              itemCount:
                  context.select<TimelineState, int>((s) => s.timeline.length),
              separatorBuilder: _buildSeparator,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, int index) {
    return const Divider(
      height: 0,
      indent: 68,
      endIndent: 12,
      color: Colors.grey,
    );
  }

  void _showError(BuildContext context, String message) {
    if (message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(message),
        ));
      });
    }
  }
}

class _TimelineViewListItem extends StatelessWidget {
  const _TimelineViewListItem(this.index, {Key key}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    final element = context.select<TimelineState, TimelineElement>(
        (n) => index < n.timeline.length ? n.timeline[index] : null);
    switch (element.runtimeType) {
      case StatusElement:
        return StatusWidget(status: (element as StatusElement).status);
      case GapElement:
        return _TimelineGap(
            isLoading: (element as GapElement).isLoading,
            onTapLoad: () async {
              await context
                  .read<TimelineController>()
                  .handleTapGap(element as GapElement);
            });
      default:
        return const SizedBox();
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
      child: isLoading ? _buildLoadingChild() : _buildGapChild(),
    );
  }

  Widget _buildGapChild() {
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

  Widget _buildLoadingChild() {
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
