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
      home: const MyHomePage(title: 'Collections'),
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
  late final _observedList = stateList<int>([]);
  late final _observedMap = stateMap<int, int>({});
  late final _observedItem = stateObject(ObservableItem());

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
                Text('stateList() ${_observedList.value.length}'),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    _observedList.value.add(_observedList.value.length);
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: const Icon(Icons.remove),
                  onPressed: () {
                    if (_observedList.value.isNotEmpty) {
                      _observedList.value.removeLast();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('stateMap() ${_observedMap.value.length}'),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    _observedMap.value[_observedMap.value.length] = 0;
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: const Icon(Icons.remove),
                  onPressed: () {
                    if (_observedMap.value.isNotEmpty) {
                      _observedMap.value.remove(_observedMap.value.length - 1);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'publishedList() ${_observedItem.value.observedList.value.length}'),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _observedItem.value.listAdd,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _observedItem.value.listRemove,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'publishedMap(): ${_observedItem.value.observedMap.value.length}'),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _observedItem.value.mapAdd,
                  child: const Icon(Icons.add),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _observedItem.value.mapRemove,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _observedList.value.clear();
          _observedMap.value.clear();
          _observedItem.value.clear();
        },
        tooltip: 'Clear',
        child: const Icon(Icons.clear),
      ),
    );
  }
}

class ObservableItem extends ObservableObject {
  late final observedList = publishedList<int>([]);
  late final observedMap = publishedMap<int, int>({});

  void clear() {
    observedList.value.clear();
    observedMap.value.clear();
  }

  void listAdd() {
    observedList.value.add(0);
  }

  void listRemove() {
    if (observedList.value.isNotEmpty) {
      observedList.value.removeLast();
    }
  }

  void mapAdd() {
    observedMap.value[observedMap.value.length] = 0;
  }

  void mapRemove() {
    if (observedMap.value.isNotEmpty) {
      observedMap.value.remove(observedMap.value.length - 1);
    }
  }
}
