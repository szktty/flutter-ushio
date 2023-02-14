import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import './observer.dart';
import './state.dart';

class ListBinding<E> with Observable, ValueWrapper<List<E>> {
  @protected
  ListBinding(List<E> value) {
    _value = ObservableList(this, value);
  }

  late ObservableList<E> _value;

  @override
  List<E> get value => _value;

  @override
  set value(List<E> newValue) {
    _value.breakDependents();
    _value = ObservableList(this, newValue);
    updateSubscriber();
  }

  void Function(List<E> newValue) get setter => (newValue) {
        this.value = newValue;
      };

  @override
  void onSubscriberUpdate() {
    updateSubscriber();
  }
}

class PublishedList<E> with Observable {
  @protected
  PublishedList(ObservableObject owner, List<E> value) {
    _owner = owner;
    addObserver(_owner);
    _value = ObservableList(this, value);
  }

  late final ObservableObject _owner;
  late ObservableList<E> _value;

  List<E> get value => _value;

  set value(List<E> newValue) {
    _value.breakDependents();
    _value = ObservableList(this, newValue);
    updateSubscriber();
  }

  void Function(List<E>?) get setter => (value) {
        if (value != null) {
          this.value = value;
        }
      };

  @override
  void onSubscriberUpdate() {
    updateSubscriber();
  }
}

class ObservableList<E> with Observable implements List<E> {
  @protected
  ObservableList(Observable observer, List<E> list) {
    _observer = observer;
    _wrapped = _wrapList(list);
    addObserver(_observer);
  }

  late final Observable _observer;

  E _wrap(E e) {
    if (e is ObservableObject) {
      e.addObserver(this);
    }
    return e;
  }

  List<E> _wrapList(List<E> list) {
    return list.map(_wrap).toList(growable: true);
  }

  void _unwrap(E e) {
    if (e is ObservableObject) {
      e.removeObserver(this);
    }
  }

  void _unwrapList(List<E> es) {
    for (final e in es) {
      _unwrap(e);
    }
  }

  void _unwrapAll() {
    _unwrapList(_wrapped);
  }

  void _unwrapRange(int start, int end) {
    for (final e in _wrapped.getRange(start, end)) {
      _unwrap(e);
    }
  }

  late final List<E> _wrapped;

  @override
  E get first => _wrapped.first;

  @override
  E get last => _wrapped.last;

  @override
  int get length => _wrapped.length;

  @override
  set first(E value) {
    _unwrap(first);
    _wrapped.first = _wrap(value);
    updateSubscriber();
  }

  @override
  set last(E value) {
    _unwrap(last);
    _wrapped.last = _wrap(value);
    updateSubscriber();
  }

  @override
  set length(int newLength) {
    if (newLength > _wrapped.length) {
      for (var i = _wrapped.length; i < newLength; i++) {
        _unwrap(_wrapped[i]);
      }
    }
    _wrapped.length = newLength;
    updateSubscriber();
  }

  @override
  List<E> operator +(List<E> other) {
    return _wrapped + other;
  }

  @override
  E operator [](int index) {
    return _wrapped[index];
  }

  @override
  void operator []=(int index, E value) {
    _unwrap(_wrapped[index]);
    _wrapped[index] = _wrap(value);
    updateSubscriber();
  }

  @override
  void add(E value) {
    _wrapped.add(value);
    updateSubscriber();
  }

  @override
  void addAll(Iterable<E> iterable) {
    final list = iterable.toList();
    _wrapList(list);
    _wrapped.addAll(list);
    updateSubscriber();
  }

  @override
  bool any(bool Function(E element) test) {
    return _wrapped.any(test);
  }

  @override
  Map<int, E> asMap() {
    return _wrapped.asMap();
  }

  @override
  List<R> cast<R>() {
    return _wrapped.cast();
  }

  @override
  void clear() {
    _unwrapAll();
    _wrapped.clear();
    updateSubscriber();
  }

  @override
  bool contains(Object? element) {
    return _wrapped.contains(element);
  }

  @override
  E elementAt(int index) {
    return _wrapped.elementAt(index);
  }

  @override
  bool every(bool Function(E element) test) {
    return _wrapped.every(test);
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) toElements) {
    return _wrapped.expand(toElements);
  }

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    _unwrapRange(start, end);
    if (fillValue != null) {
      _wrap(fillValue);
    }
    _wrapped.fillRange(start, end, fillValue);
    updateSubscriber();
  }

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _wrapped.firstWhere(test, orElse: orElse);
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) {
    return _wrapped.fold(initialValue, combine);
  }

  @override
  Iterable<E> followedBy(Iterable<E> other) {
    return _wrapped.followedBy(other);
  }

  @override
  void forEach(void Function(E element) action) {
    _wrapped.forEach(action);
  }

  @override
  Iterable<E> getRange(int start, int end) {
    return _wrapped.getRange(start, end);
  }

  @override
  int indexOf(E element, [int start = 0]) {
    return _wrapped.indexOf(element, start);
  }

  @override
  int indexWhere(bool Function(E element) test, [int start = 0]) {
    return _wrapped.indexWhere(test, start);
  }

  @override
  void insert(int index, E element) {
    _wrapped.insert(index, _wrap(element));
    updateSubscriber();
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    for (final e in iterable) {
      _wrap(e);
    }
    _wrapped.insertAll(index, iterable);
    updateSubscriber();
  }

  @override
  bool get isEmpty => _wrapped.isEmpty;

  @override
  bool get isNotEmpty => _wrapped.isNotEmpty;

  @override
  Iterator<E> get iterator => _wrapped.iterator;

  @override
  String join([String separator = ""]) {
    return _wrapped.join(separator);
  }

  @override
  int lastIndexOf(E element, [int? start]) {
    return _wrapped.lastIndexOf(element, start);
  }

  @override
  int lastIndexWhere(bool Function(E element) test, [int? start]) {
    return _wrapped.lastIndexWhere(test, start);
  }

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _wrapped.lastWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> map<T>(T Function(E e) toElement) {
    return _wrapped.map(toElement);
  }

  @override
  E reduce(E Function(E value, E element) combine) {
    return _wrapped.reduce(combine);
  }

  @override
  bool remove(Object? value) {
    if (value is E) {
      _unwrap(value);
    }
    final res = _wrapped.remove(value);
    updateSubscriber();
    return res;
  }

  @override
  E removeAt(int index) {
    final e = _wrapped.removeAt(index);
    _unwrap(e);
    updateSubscriber();
    return e;
  }

  @override
  E removeLast() {
    final last = _wrapped.removeLast();
    _unwrap(last);
    updateSubscriber();
    return last;
  }

  @override
  void removeRange(int start, int end) {
    _unwrapRange(start, end);
    _wrapped.removeRange(start, end);
    updateSubscriber();
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _wrapped.removeWhere((element) {
      final res = test(element);
      if (res) {
        _unwrap(element);
      }
      return res;
    });
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacements) {
    _unwrapRange(start, end);
    _wrapped.replaceRange(start, end, replacements);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _wrapped.retainWhere((element) {
      final res = test(element);
      if (res) {
        _unwrap(element);
      }
      return res;
    });
  }

  @override
  Iterable<E> get reversed => _wrapped.reversed;

  @override
  void setAll(int index, Iterable<E> iterable) {
    final list = List<E>.from(iterable);
    _wrapList(list);
    _wrapped.setAll(index, list);
    updateSubscriber();
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    print('setRange $_wrapped');
    for (var i = start; i < end; i++) {
      _unwrap(_wrapped[i]);
    }
    for (final e in iterable.skip(skipCount)) {
      _wrap(e);
    }
    _wrapped.setRange(start, end, iterable, skipCount);
    updateSubscriber();
  }

  @override
  void shuffle([Random? random]) {
    _wrapped.shuffle(random);
    updateSubscriber();
  }

  @override
  E get single => _wrapped.single;

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _wrapped.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<E> skip(int count) {
    return _wrapped.skip(count);
  }

  @override
  Iterable<E> skipWhile(bool Function(E value) test) {
    return _wrapped.skipWhile(test);
  }

  @override
  void sort([int Function(E a, E b)? compare]) {
    _wrapped.sort(compare);
    updateSubscriber();
  }

  @override
  List<E> sublist(int start, [int? end]) {
    return _wrapped.sublist(start, end);
  }

  @override
  Iterable<E> take(int count) {
    return _wrapped.take(count);
  }

  @override
  Iterable<E> takeWhile(bool Function(E value) test) {
    return _wrapped.takeWhile(test);
  }

  @override
  List<E> toList({bool growable = true}) {
    return _wrapped.toList(growable: growable);
  }

  @override
  Set<E> toSet() {
    return _wrapped.toSet();
  }

  @override
  Iterable<E> where(bool Function(E element) test) {
    return _wrapped.where(test);
  }

  @override
  Iterable<T> whereType<T>() {
    return _wrapped.whereType();
  }
}
