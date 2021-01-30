import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformToggleButtons extends PlatformWidgetBase {
  const PlatformToggleButtons({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Widget createCupertinoWidget(BuildContext context) {
    // TODO: implement createCupertinoWidget
    throw UnimplementedError();
  }

  @override
  Widget createMaterialWidget(BuildContext context) {
    // TODO: implement createMaterialWidget
    throw UnimplementedError();
  }
}
