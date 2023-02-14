import 'package:flutter/foundation.dart';

import './observer.dart';
import './state.dart';

class MapBinding<K, V> with Observable, ValueWrapper<Map<K, V>> {
  @protected
  MapBinding(Map<K, V> value) {
    _value = ObservableMap(this, value);
  }

  late ObservableMap<K, V> _value;

  @override
  Map<K, V> get value => _value;

  @override
  set value(Map<K, V> newValue) {
    _value.breakDependents();
    _value = ObservableMap(this, newValue);
    updateSubscriber();
  }

  void Function(Map<K, V> newValue) get setter => (newValue) {
        this.value = newValue;
      };

  @override
  void onSubscriberUpdate() {
    updateSubscriber();
  }
}

class PublishedMap<K, V> with Observable, ValueWrapper<Map<K, V>> {
  PublishedMap(ObservableObject owner, Map<K, V> value) {
    _owner = owner;
    _value = ObservableMap(this, value)..addObserver(this);
    addObserver(_owner);
  }

  late final ObservableObject _owner;
  late ObservableMap<K, V> _value;

  @override
  Map<K, V> get value => _value;

  @override
  set value(Map<K, V> newValue) {
    _value._reset(newValue);
  }

  void Function(Map<K, V>?) get setter => (value) {
        if (value != null) {
          this.value = value;
        }
      };

  @override
  @protected
  void onSubscriberUpdate() {
    updateSubscriber();
  }
}

class ObservableMap<K, V> with Observable implements Map<K, V> {
  ObservableMap(Observable observer, Map<K, V> value) {
    _wrapped = {};
    _reset(value);
    addObserver(observer);
  }

  late Map<K, V> _wrapped;

  @override
  @protected
  void onSubscriberUpdate() {
    super.updateSubscriber();
  }

  T _wrap<T>(T value) {
    if (value is ObservableObject) {
      value.addObserver(this);
    }
    return value;
  }

  Map<K, V> _wrapMap(Map<K, V> map) {
    for (final key in map.keys) {
      final value = map[key];
      _wrap(key);
      _wrap(value);
    }
    return map;
  }

  void _unwrap<T>(T value) {
    if (value is ObservableObject) {
      value.removeObserver(this);
    }
  }

  void _unwrapAll(Map<K, V> map) {
    for (final key in map.keys) {
      _unwrap(key);
      _unwrap(map[key]);
    }
  }

  void _reset(Map<K, V> newValue) {
    for (final key in newValue.keys) {
      this[_wrap(key)] = _wrap(newValue[key] as V);
    }
  }

  @override
  V? operator [](Object? key) {
    return _wrapped[key];
  }

  @override
  void operator []=(K key, V value) {
    final old = _wrapped[key];
    if (old != null) {
      _unwrap(old);
    }
    _wrapped[_wrap(key)] = _wrap(value);
    updateSubscriber();
  }

  @override
  void addAll(Map<K, V> other) {
    _wrapMap(other);
    _wrapped.addAll(other);
    updateSubscriber();
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    for (final entry in newEntries) {
      _wrap(entry.key);
      _wrap(entry.value);
    }
    _wrapped.addEntries(newEntries);
    updateSubscriber();
  }

  @override
  Map<RK, RV> cast<RK, RV>() {
    return _wrapped.cast();
  }

  @override
  void clear() {
    _unwrapAll(_wrapped);
    _wrapped.clear();
  }

  @override
  bool containsKey(Object? key) {
    return _wrapped.containsKey(key);
  }

  @override
  bool containsValue(Object? value) {
    return _wrapped.containsValue(value);
  }

  @override
  Iterable<MapEntry<K, V>> get entries => _wrapped.entries;

  @override
  void forEach(void Function(K key, V value) action) {
    _wrapped.forEach(action);
  }

  @override
  bool get isEmpty => _wrapped.isEmpty;

  @override
  bool get isNotEmpty => _wrapped.isNotEmpty;

  @override
  Iterable<K> get keys => _wrapped.keys;

  @override
  int get length => _wrapped.length;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) {
    return _wrapped.map(convert);
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    final old = _wrapped[key];
    final value = _wrapped.putIfAbsent(key, ifAbsent);
    if (old != value) {
      _unwrap(old);
      _wrap(value);
      updateSubscriber();
    }
    return value;
  }

  @override
  V? remove(Object? key) {
    final value = _wrapped.remove(key);
    _unwrap(key);
    _unwrap(value);
    updateSubscriber();
    return value;
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    _wrapped.removeWhere((key, value) {
      final res = test(key, value);
      if (res) {
        _unwrap(key);
        _unwrap(value);
      }
      return res;
    });
    updateSubscriber();
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    final old = _wrapped[key];
    _unwrap(old);
    final newValue = _wrapped.update(key, update, ifAbsent: ifAbsent);
    _wrap(newValue);
    updateSubscriber();
    return newValue;
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    _wrapped.updateAll((key, value) {
      final old = _wrapped[key] as V;
      final newValue = update(key, old);
      _unwrap(old);
      _wrap(newValue);
      return newValue;
    });
    updateSubscriber();
  }

  @override
  Iterable<V> get values => _wrapped.values;
}
