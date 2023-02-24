import 'package:synchronized/synchronized.dart';
import 'package:ushio/src/combine/cancellable.dart';
import 'package:ushio/src/combine/subscribers.dart';
import 'package:ushio/src/state.dart';

import './publishers.dart';
import './subscriptions.dart';

abstract class Subject<Output, Failure extends Error>
    implements Publisher<Output, Failure> {
  void send(Output? value);
  void request(Subscription subscription);
  void finish();
  void failure(Failure failure);
}

class PassthroughSubject<Output, Failure extends Error>
    implements Subject<Output, Failure> {
  final _lock = Lock();
  var _active = true;
  //final _downstreams =
  @override
  AnyCancellable assign(Binding<Output> binding) {
    // TODO: implement assign
    throw UnimplementedError();
  }

  @override
  void failure(Failure failure) {
    // TODO: implement failure
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
  void request(Subscription subscription) {
    // TODO: implement request
    _lock.synchronized(() => null);
  }

  @override
  void send(Output? value) {
    // TODO: implement send
  }

  @override
  AnyCancellable subscribe<S extends Subscriber<dynamic, Error>>(S subscriber) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  AnyCancellable sink({
    required void Function(Output p1) onReceive,
    void Function(Completion<Failure> p1)? onCompletion,
  }) {
    // TODO: implement sink
    throw UnimplementedError();
  }
}
