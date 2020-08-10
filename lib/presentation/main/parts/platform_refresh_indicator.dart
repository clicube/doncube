import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformRefreshIndicator extends PlatformWidgetBase {
  PlatformRefreshIndicator({
    @required this.childDelegate,
    this.onRefresh,
    Key key,
  }) : super(key: key);
  final SliverChildDelegate childDelegate;
  final Future<void> Function() onRefresh;

  @override
  Widget createCupertinoWidget(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: onRefresh),
        SliverList(delegate: childDelegate),
      ],
    );
  }

  @override
  Widget createMaterialWidget(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        slivers: [
          SliverList(delegate: childDelegate),
        ],
      ),
    );
  }
}
