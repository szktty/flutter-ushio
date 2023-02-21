import 'package:flutter/foundation.dart';

class Cancellable {
  @protected
  const Cancellable(this.onCancelled);

  final void Function() onCancelled;

  void cancel() {
    onCancelled();
  }
}

class Publisher<Output, Failure extends Error> {
  late final _subscribers = <dynamic, Cancellable>{};

  void receive<S>(S subscriber) {
    if (!_subscribers.containsKey(subscriber)) {
      // TODO
      _subscribers[subscriber] = Cancellable(() {
        _subscribers.remove(subscriber);
      });
    }
  }

  Cancellable subscribe<S>() {
    throw UnimplementedError();
  }

  void assign(Publisher<Output, Failure> publisher) {
    throw UnimplementedError();
  }

  Cancellable sink({
    required void Function(Output) onReceive,
    required void Function(Failure)? onFailure,
  }) {
    throw UnimplementedError();
  }
}

class Subscriber<Output, Failure extends Error>
    extends Publisher<Output, Failure> {
  void send(Output? value) {
    throw UnimplementedError();
  }

  void fail(Failure value) {
    throw UnimplementedError();
  }

  void finish() {
    throw UnimplementedError();
  }
}
