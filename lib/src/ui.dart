import 'package:flutter/material.dart' hide Icons;
import 'package:flutter_utils/arch.dart';
import 'package:functional/functional.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'models.dart';
import 'states.dart';
import 'actions.dart' as Actions;
import 'icons.dart' as Icons;
import 'package:intl/intl.dart';

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

void initHome(BuildContext context) {
  Provider.of<HomeState>(context).dispatchAsync(Actions.load);
}

Widget buildHome(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Title',
          style: TextStyle(letterSpacing: 1),
        ),
        centerTitle: true,
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
                  ? state.allTodos
                  : state.pageIndex == 1
                      ? state.runningTodos
                      : state.finishedTodos;
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) =>
                    _todoTile(context, todos[index]),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .pushNamed('/home/edit', arguments: Todo.create(''));
        },
      ),
      bottomNavigationBar: ProducingConsumer<HomeState>(
        builder: (context, dispatcher, state) => BottomNavigationBar(
          currentIndex: state.pageIndex,
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
      onTap: () {
        showDialog(context: context, builder: _todoDialog % todo);
      },
    );

Widget _todoDialog(Todo todo, BuildContext context) => SimpleDialog(
      title: Text(todo.name),
      children: <Widget>[
        Container(),
        Row(
          children: <Widget>[
            Producer<HomeState>(
              builder: (context, dispatcher) => FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  dispatcher.dispatchAsync(Actions.delete % todo);
                },
                child: Text('Delete'),
              ),
            ),
            Producer<HomeState>(
              builder: (context, dispatcher) => FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/home/edit', arguments: todo);
                },
                child: Text('Edit'),
              ),
            ),
          ],
        ),
      ],
    );

/* ----------------- EditTodo ------------------ */

Widget buildEditTodo(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Add Todo'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Builder(
            builder: _todoForm,
          ),
        ),
      ),
    );

Widget _todoForm(BuildContext context) {
  final key = GlobalKey<FormBuilderState>();
  final Todo todo = ModalRoute.of(context).settings.arguments;
  return FormBuilder(
    key: key,
    initialValue: todo.toMap(),
    child: Column(
      children: [
        FormBuilderTextField(
          attribute: Todo.NAME,
          decoration: InputDecoration(labelText: 'Todo Name'),
        ),
        FormBuilderDateTimePicker(
          attribute: Todo.DUE_DATE,
          decoration: InputDecoration(labelText: 'Due Date'),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: FormBuilderSlider(
            label: 'Progress',
            divisions: 100,
            min: 0.0,
            max: 100.0,
            initialValue: todo.progress,
            attribute: Todo.PROGRESS,
            decoration: InputDecoration(
                labelText: 'Progress', border: InputBorder.none),
            numberFormat: NumberFormat('##0'),
          ),
        ),
        Producer<HomeState>(
          builder: (context, dispatcher) => FlatButton(
            child: Text(todo.key != null ? 'Update' : 'Add'),
            onPressed: () {
              if (key.currentState.validate()) {
                key.currentState.save();
                final newTodo = todo.copyWithMap(key.currentState.value);
                dispatcher.dispatchAsync(Actions.update % newTodo);
                Navigator.of(context).popUntil((settings) {
                  if (settings.isFirst) return true;
                  return false;
                });
              }
            },
          ),
        ),
      ],
    ),
  );
}
