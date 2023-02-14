import 'package:flutter/material.dart';
import 'package:ushio/ushio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Environment(
        values: [Counter()],
        child: const MyHomePage(title: 'Multi Counter'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ManagedState<MyHomePage> {
  late final _counter = state(0);

  void _incrementCounter() {
    _counter.value++;
  }

  void _clear() {
    _counter.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'state() ${_counter.value}',
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const StateCounterView(),
            const StateObjectCounterView(),
            const EnvironmentObjectCounterView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clear,
        tooltip: 'Clear',
        child: const Icon(Icons.clear),
      ),
    );
  }
}

class Counter extends ObservableObject {
  late final count = published(0);

  void incrementCounter() {
    count.value++;
  }
}

class StateCounterView extends StatefulWidget {
  const StateCounterView({super.key});

  @override
  State<StatefulWidget> createState() => _StateCounterViewState();
}

class _StateCounterViewState extends ManagedState<StateCounterView> {
  late final _count = state(0);

  void _incrementCounter() {
    _count.value++;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'child state() ${_count.value}',
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class StateObjectCounterView extends StatefulWidget {
  const StateObjectCounterView({super.key});

  @override
  State<StatefulWidget> createState() => _StateObjectCounterViewState();
}

class _StateObjectCounterViewState
    extends ManagedState<StateObjectCounterView> {
  late final _counter = stateObject(Counter());

  void _incrementCounter() {
    _counter.value.incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'stateObject() ${_counter.value.count.value}',
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class EnvironmentObjectCounterView extends StatefulWidget {
  const EnvironmentObjectCounterView({super.key});

  @override
  State<StatefulWidget> createState() => _EnvironmentObjectCounterViewState();
}

class _EnvironmentObjectCounterViewState
    extends ManagedState<EnvironmentObjectCounterView> {
  late final _counter = environmentObject<Counter>();

  void _incrementCounter(BuildContext context) {
    _counter.value(context).incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'environmentObject() ${_counter.value(context).count.value}',
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            _incrementCounter(context);
          },
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
