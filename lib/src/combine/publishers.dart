import 'package:ushio/src/state.dart';

import './cancellable.dart';
import './subscribers.dart';

abstract class Publisher<Output, Failure extends Error> {
  void receive<S extends Subscriber>(S subscriber);
  AnyCancellable subscribe<S extends Subscriber>(S subscriber);
  AnyCancellable assign(Binding<Output> binding);
  AnyCancellable sink({
    required void Function(Output) onReceive,
    void Function(Completion<Failure>)? onCompletion,
  });
}

class _PublisherSink<Output, Failure extends Error> {
  _PublisherSink({
    required this.onReceive,
    required this.onCompletion,
  });
  void Function(Output) onReceive;
  void Function(Completion<Failure>)? onCompletion;
}

class AnyPublisher<Output, Failure extends Error>
    implements Publisher<Output, Failure> {
  late final _subscribers = <Subscriber, AnyCancellable>{};
  late final _sinks = <_PublisherSink<Output, Failure>, AnyCancellable>{};

  @override
  void receive<S extends Subscriber>(S subscriber) {
    subscribe(subscriber);
  }

  @override
  AnyCancellable subscribe<S extends Subscriber>(S subscriber) {
    AnyCancellable? cancel = _subscribers[subscriber];
    if (cancel == null) {
      cancel = AnyCancellable(() {
        _subscribers.remove(subscriber);
      });
      _subscribers[subscriber] = cancel;
    }
    return cancel;
  }

  @override
  AnyCancellable assign(Binding<Output> binding) {
    return sink(onReceive: (value) {
      binding.value = value;
    });
  }

  @override
  AnyCancellable sink({
    required void Function(Output) onReceive,
    void Function(Completion<Failure>)? onCompletion,
  }) {
    final sink =
        _PublisherSink(onReceive: onReceive, onCompletion: onCompletion);
    final cancel = AnyCancellable(() {
      _sinks.remove(sink);
    });
    _sinks[sink] = cancel;
    return cancel;
  }
}
