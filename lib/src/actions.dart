import 'dart:async';
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
