import 'dart:async';
import 'dart:collection';
import 'models.dart';
import 'states.dart';
import 'package:flutter_utils/database.dart' as Db;

FutureOr<HomeState> update(Todo todo, HomeState state) async {
  if (todo.key != null) {
    Db.update(
      state.client,
      state.todoStore,
      todo.toJson(),
    );
    return state.copyWith(todos: state.todos..[todo.key] = todo);
  } else {
    final key = await Db.insert(state.client, state.todoStore, todo.toJson());
    return state.copyWith(todos: state.todos..[key] = todo.copyWith(key: key));
  }
}

FutureOr<HomeState> delete(Todo todo, HomeState state) async {
  await Db.delete(state.client, state.todoStore, todo.key);
  return state.copyWith(todos: state.todos..remove(todo.key));
}

FutureOr<HomeState> load(HomeState state) async {
  final snapshots = await Db.find(state.client, state.todoStore);
  final todos = HashMap<String, Todo>();
  todos.addEntries(snapshots
      .map((record) => MapEntry(record.key, Todo.fromJson(record.value))));
  return state.copyWith(todos: todos);
}
