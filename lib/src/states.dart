import 'models.dart';
import 'package:sembast/sembast.dart';

class HomeState {
  final int pageIndex;
  final Map<String, Todo> todos;
  final StoreRef todoStore;
  final Database client;

  List<Todo> get allTodos => todos.values.toList();

  List<Todo> get runningTodos =>
      todos.values.where((todo) => todo.progress < 100).toList();
  List<Todo> get finishedTodos =>
      todos.values.where((todo) => todo.progress == 100).toList();

  HomeState({
    this.pageIndex,
    this.todos,
    this.todoStore,
    this.client,
  });

  HomeState copyWith({
    int pageIndex,
    Map<String, Todo> todos,
    StoreRef todoStore,
    Database client,
  }) =>
      HomeState(
        pageIndex: pageIndex ?? this.pageIndex,
        todos: todos ?? this.todos,
        client: client ?? this.client,
        todoStore: todoStore ?? this.todoStore,
      );
}

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
