import 'package:flutter/widgets.dart';

import './list.dart';
import './map.dart';
import './observer.dart';

abstract class ManagedState<W extends StatefulWidget> extends State<W>
    with Observable {
  @override
  void dispose() {
    breakDependents();
    super.dispose();
  }

  @override
  @protected
  void onSubscriberUpdate() {
    updateSubscriber();
    setState(() {});
  }

  @protected
  Binding<T> state<T>(T value) {
    return Binding(value)..addObserver(this);
  }

  @protected
  ListBinding<T> stateList<T>(List<T> value) {
    return ListBinding(value)..addObserver(this);
  }

  @protected
  MapBinding<K, V> stateMap<K, V>(Map<K, V> value) {
    return MapBinding(value)..addObserver(this);
  }

  @protected
  StateObject<T> stateObject<T extends ObservableObject>(T value) {
    return StateObject(value)..addObserver(this);
  }

  @protected
  EnvironmentObject<T> environmentObject<T extends ObservableObject>() {
    return EnvironmentObject(this);
  }
}

abstract class ValueWrapper<T> {
  T get value;
  set value(T newValue);

  @override
  bool operator ==(Object other) {
    return value == other;
  }

  @override
  int get hashCode => value.hashCode;
}

class Binding<T> with Observable, ValueWrapper<T> {
  @protected
  Binding(T value) {
    _value = value;
  }

  late T _value;

  @override
  T get value => _value;

  @override
  set value(T newValue) {
    if (value == newValue) {
      return;
    }
    _value = newValue;
    updateSubscriber();
  }

  void Function(T newValue) get setter => (newValue) {
        this.value = newValue;
      };
}

class StateObject<T extends ObservableObject> with Observable {
  @protected
  StateObject(T value) {
    _value = value..addObserver(this);
  }

  late final T _value;

  T get value => _value;

  @override
  @protected
  void onSubscriberUpdate() {
    updateSubscriber();
  }
}

abstract class ObservableObject with Observable {
  @protected
  Published<T> published<T>(T value) {
    return Published(this, value);
  }

  @protected
  PublishedList<E> publishedList<E>(List<E> value) {
    return PublishedList(this, value);
  }

  @protected
  PublishedMap<K, V> publishedMap<K, V>(Map<K, V> value) {
    return PublishedMap(this, value);
  }
}

class Published<T> with Observable, ValueWrapper<T> {
  @protected
  Published(ObservableObject owner, T value) {
    _owner = owner;
    _value = value;
    addObserver(_owner);
  }

  late final ObservableObject _owner;
  late T _value;

  @override
  T get value => _value;

  @override
  set value(T newValue) {
    if (value == newValue) {
      return;
    }
    _value = newValue;
    updateSubscriber();
  }

  void Function(T?) get setter => (value) {
        if (value != null) {
          this.value = value;
        }
      };
}

class Environment extends InheritedWidget with Observable {
  Environment({
    super.key,
    List<ObservableObject>? values,
    required super.child,
  }) {
    _values = {};
    for (final value in values ?? []) {
      _values[value.runtimeType] = value;
    }
  }

  late final Map<Type, ObservableObject> _values;

  T value<T extends ObservableObject>(BuildContext context) {
    return _values[T] as T;
  }

  static Environment of(BuildContext context) {
    final env = context.dependOnInheritedWidgetOfExactType<Environment>();
    assert(env != null, 'Environment not found');
    return env!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class EnvironmentObject<T extends ObservableObject> with Observable {
  @protected
  EnvironmentObject(ManagedState state) {
    _state = state;
  }

  late final ManagedState _state;

  T value(BuildContext context) {
    final env = Environment.of(context);
    final value = env.value<T>(context);
    addObserver(env);
    env.addObserver(_state);
    value.addObserver(this);
    return value;
  }
}
