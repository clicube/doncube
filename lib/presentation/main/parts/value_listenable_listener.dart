import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ValueListenableListener<T> extends StatefulWidget {
  const ValueListenableListener(
      {Key key, this.valueListenable, this.onChange, this.child})
      : super(key: key);
  final ValueListenable<T> valueListenable;
  final ValueChanged<T> onChange;
  final Widget child;

  @override
  _ValueListenableListenerState<T> createState() =>
      _ValueListenableListenerState();
}

class _ValueListenableListenerState<T>
    extends State<ValueListenableListener<T>> {
  @override
  void initState() {
    super.initState();
    widget.valueListenable?.addListener(_listener);
    _listener();
  }

  @override
  void didUpdateWidget(ValueListenableListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable?.removeListener(_listener);
      widget.valueListenable?.addListener(_listener);
      _listener();
    }
  }

  @override
  void dispose() {
    widget.valueListenable?.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    widget.onChange?.call(widget.valueListenable.value);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
