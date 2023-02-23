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

abstract class Publisher<Output, Failure extends Error> {
  void receive<S extends Subscriber>(S subscriber);
  Cancellable subscribe<S extends Subscriber>(S subscriber);
  void assign(Publisher<Output, Failure> publisher);
  Cancellable sink({
    required void Function(Output) onReceive,
    required void Function(Failure?)? onFinish,
  });
}

class AnyPublisher<Output, Failure extends Error>
    implements Publisher<Output, Failure> {
  late final _subscribers = <Subscriber, Cancellable>{};

  @override
  void receive<S extends Subscriber>(S subscriber) {
    subscribe(subscriber);
  }

  @override
  Cancellable subscribe<S extends Subscriber>(S subscriber) {
    Cancellable? cancel = _subscribers[subscriber];
    if (cancel == null) {
      cancel = AnyCancellable(() {
        _subscribers.remove(subscriber);
      });
      _subscribers[subscriber] = cancel;
    }
    return cancel;
  }

  @override
  void assign(Publisher<Output, Failure> publisher) {
    throw UnimplementedError();
  }

  @override
  Cancellable sink({
    required void Function(Output) onReceive,
    required void Function(Failure?)? onFinish,
  }) {
    throw UnimplementedError();
  }
}

abstract class Subject<Output, Failure extends Error>
    implements Publisher<Output, Failure> {
  void send(Output? value);
  void request(Subscription subscription);
  void finish();
  void failure(Failure failure);
}

// TODO
abstract class Subscription {}

abstract class Subscriber<Output, Failure extends Error>
    implements Publisher<Output, Failure> {
  void send(Output? value);
  void fail(Failure value);
  void finish();
}

class Sink<Output, Failure extends Error>
    implements Subscriber<Output, Failure>, Cancellable {
  @protected
  Sink({
    required void Function(Output) onReceive,
    required void Function(Failure)? onFailure,
  }) {
    _onReceive = onReceive;
    _onFailure = onFailure;
  }

  late void Function(Output) _onReceive;
  void Function(Failure)? _onFailure;

  @override
  void assign(Publisher<Output, Failure> publisher) {
    // TODO: implement assign
  }

  @override
  void cancel() {
    // TODO: implement cancel
  }

  @override
  void fail(Failure value) {
    // TODO: implement fail
  }

  @override
  void finish() {
    // TODO: implement finish
  }

  @override
  void receive<S extends Subscriber<dynamic, Error>>(S subscriber) {
    // TODO: implement receive
  }

  @override
  void send(Output? value) {
    // TODO: implement send
  }

  @override
  Cancellable sink(
      {required void Function(Output p1) onReceive,
      required void Function(Failure? p1)? onFinish}) {
    // TODO: implement sink
    throw UnimplementedError();
  }

  @override
  Cancellable subscribe<S extends Subscriber<dynamic, Error>>(S subscriber) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }
}
