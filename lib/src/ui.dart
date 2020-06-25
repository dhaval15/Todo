import 'package:flutter/material.dart' hide Icons;
import 'package:flutter_utils/arch.dart';
import 'package:functional/functional.dart';
import 'models.dart';
import 'states.dart';
import 'actions.dart' as Actions;
import 'icons.dart' as Icons;

/* ----------------- Splash ------------------ */

void initSplash(BuildContext context) async {
  await Future.delayed(Duration(seconds: 3));
  Navigator.of(context).pushReplacementNamed('/home');
}

Widget buildSplash(BuildContext context) => Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'Todo',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ),
    );

/* ------------------- Home -------------------- */

Widget buildHome(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Consumer<HomeState>(
          rebuild: (context, oldState, newState) async {
            if (newState.pageIndex == oldState.pageIndex)
              return RebuildAction.skip;
            return RebuildAction.rebuild;
          },
          builder: (context, state) => Consumer<HomeState>(
            /*rebuild: (context, oldState, newState) async {
              if (newState.pageIndex != oldState.pageIndex)
                return RebuildAction.skip;
              return RebuildAction.rebuild;
            },*/
            builder: (context, state) {
              final todos = state.pageIndex == 0
                  ? state.todos
                  : state.pageIndex == 1
                      ? state.runningTodos
                      : state.finishedTodos;
              return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, index) =>
                    _todoTile(context, todos[index]),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Producer<HomeState>(
        builder: (context, dispatcher) => BottomNavigationBar(
          onTap: (index) {
            dispatcher.dispatch((state) => state.copyWith(pageIndex: index));
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.running),
              title: Text('Runnung'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.completed),
              title: Text('Finished'),
            ),
          ],
        ),
      ),
    );

Widget _todoTile(BuildContext context, Todo todo) => ListTile(
      trailing: CircleAvatar(
        child: Text(
          '${todo.progress}',
        ),
      ),
      title: Text(todo.name),
      onTap: () {},
    );

/* ----------------- EditTodo ------------------ */

Widget buildEditTodo(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Producer<EditTodoState>(
          builder: (context, dispatcher) => TextFormField(
            onFieldSubmitted: (text) {
              final action = ((EditTodoState state) =>
                      state.copyWith(todo: state.todo.copyWith(name: text))) |
                  (Actions.save);
              dispatcher.mutateAsync(action);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: Container(child: Builder(builder: _todoForm)),
    );

Widget _todoForm(BuildContext context) {
  final key = GlobalKey<FormFieldState>();
  return FormField(
    key: key,
    builder: (context) => Producer<EditTodoState>(
      builder: (context, dispatcher) => Column(
        children: [
          TextFormField(
            onSaved: (text) {
              dispatcher.mutate((state) =>
                  state.copyWith(todo: state.todo.copyWith(name: text)));
            },
            decoration: InputDecoration(labelText: 'Todo Name'),
          ),
          FlatButton(
            child: Text('Add'),
            onPressed: () {
              if (key.currentState.validate()) {
                key.currentState.save();
                dispatcher.dispatchAsync(Actions.save);
              }
            },
          ),
        ],
      ),
    ),
  );
}
