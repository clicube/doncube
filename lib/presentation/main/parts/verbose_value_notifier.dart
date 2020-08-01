import 'package:flutter/foundation.dart';

class VerboseValueNotifier<T> extends ChangeNotifier
    implements ValueNotifier<T>, ValueListenable<T> {
  VerboseValueNotifier(this._value);

  T _value;

  @override
  T get value => _value;

  @override
  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
