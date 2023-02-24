import 'package:flutter/foundation.dart';

abstract class Cancellable {
  void cancel();
}

class AnyCancellable implements Cancellable {
  @protected
  const AnyCancellable(this._onCancelled);

  final void Function() _onCancelled;

  @override
  void cancel() {
    _onCancelled();
  }
}
