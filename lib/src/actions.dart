import 'dart:async';
import 'models.dart';
import 'states.dart';
import 'package:flutter_utils/database.dart' as Db;

FutureOr<EditTodoState> save(EditTodoState state) async {
  if (state.todo.key != null) {
    Db.update(
      state.client,
      state.todoStore,
      state.todo.toJson(),
    );
    return state;
  } else {
    final key =
        await Db.insert(state.client, state.todoStore, state.todo.toJson());
    return state.copyWith(todo: state.todo.copyWith(key: key));
  }
}

FutureOr<HomeState> delete(Todo todo, HomeState state) async {
  await Db.delete(state.client, state.todoStore, todo.key);
  return state.copyWith(todos: state.todos..remove(todo.key));
}

FutureOr<HomeState> update(Todo todo, HomeState state) async {
  await Db.update(state.client, state.todoStore, todo.toJson());
  return state.copyWith(todos: state.todos..[todo.key] = todo);
}
