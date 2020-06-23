import 'models.dart';
import 'package:sembast/sembast.dart';

class EditTodoState {
  final Todo todo;
  final StoreRef todoStore;
  final Database client;

  EditTodoState({this.todo, this.todoStore, this.client});

  EditTodoState copyWith({Todo todo, StoreRef todoStore, Database client}) =>
      EditTodoState(
        todo: todo ?? this.todo,
        todoStore: todoStore ?? this.todoStore,
        client: client ?? this.client,
      );
}
