import './cancellable.dart';

abstract class Subscription implements Cancellable {}

class EmptySubscription implements Subscription {
  @override
  void cancel() {
    // TODO: implement cancel
  }
}
