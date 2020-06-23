import 'package:flutter/material.dart';
import 'package:flutter_utils/arch.dart';
import 'package:functional/functional.dart';
import 'states.dart';
import 'actions.dart' as Actions;

/* ----------------- Splash ------------------ */

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
      body: Container(),
    );
