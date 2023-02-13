import 'package:flutter/material.dart';
import 'package:ushio/ushio.dart';

void main() {
  runApp(const MyApp());
}

class TodoList extends ObservableObject {
  late final items = publishedList([
    TodoListItem(),
  ]);
}

class TodoListItem extends ObservableObject {
  late final done = published(false);
  late final description = published('');
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
        values: [TodoList()],
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends ManagedState<MyHomePage> {
  late final todoList = environmentObject<TodoList>();

  void _createItem(BuildContext context) {
    final list = todoList.value(context);
    final item = TodoListItem();
    list.items.value.add(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            TodoListView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createItem(context);
        },
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  State<StatefulWidget> createState() => TodoListViewState();
}

class TodoListViewState extends ManagedState<TodoListView> {
  late final list = environmentObject<TodoList>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: list.value(context).items.value.map((item) {
        return Row(children: [
          Checkbox(
            value: item.done.value,
            onChanged: item.done.setter,
          ),
          Expanded(
            child: TextField(
              onChanged: item.description.setter,
            ),
          ),
        ]);
      }).toList(),
    );
  }
}
