import 'package:flutter/foundation.dart';

mixin Observable {
  late final List<Observable> _observers = [];
  late final List<Observable> _subscribers = [];

  void addObserver(Observable observer) {
    _observers.add(observer);
    observer._subscribers.add(this);
  }

  void removeObserver(Observable observer) {
    _observers.remove(observer);
    observer._removeSubscriber(this);
  }

  void _removeSubscriber(Observable subscriber) {
    _subscribers.remove(subscriber);
  }

  void breakDependents() {
    final subscribers = List.from(_subscribers);
    for (final subscriber in subscribers) {
      subscriber.removeObserver(this);
    }
    final observers = List.from(_observers);
    for (final observer in observers) {
      observer._removeSubscriber(this);
    }
    _observers.clear();
    _subscribers.clear();
  }

  void updateSubscriber() {
    final observers = List.of(_observers);
    for (final observer in observers) {
      observer.onSubscriberUpdate();
    }
  }

  // notify changes to observers in default implementation
  @protected
  void onSubscriberUpdate() {
    updateSubscriber();
  }
}
