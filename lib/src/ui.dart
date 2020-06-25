import 'package:flutter/material.dart';
import 'package:flutter_utils/arch.dart';
import 'package:functional/functional.dart';
import 'states.dart';
import 'actions.dart' as Actions;

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
