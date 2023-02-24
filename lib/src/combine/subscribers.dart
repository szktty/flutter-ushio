import 'package:flutter/foundation.dart';

import '../../ushio.dart';

class Completion<Failure extends Error> {
  const Completion({this.failure});
  bool get finish => failure == null;
  final Failure? failure;
}

abstract class Subscriber<Output, Failure extends Error>
    implements Publisher<Output, Failure> {
  void send(Output? value);
  void sendCompletion(Completion<Failure> completion);
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
  AnyCancellable assign(Binding<Output> publisher) {
    // TODO: implement assign
    return AnyCancellable(() {});
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
  AnyCancellable sink({
    required void Function(Output) onReceive,
    void Function(Failure? p1)? onFinish,
  }) {
    // TODO: implement sink
    throw UnimplementedError();
  }

  @override
  AnyCancellable subscribe<S extends Subscriber<dynamic, Error>>(S subscriber) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  void sendCompletion(Completion<Failure> completion) {
    // TODO: implement sendCompletion
  }
}
