import 'package:flutter/material.dart' hide Icons;
import 'package:flutter_utils/arch.dart';
import 'package:functional/functional.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'models.dart';
import 'states.dart';
import 'actions.dart' as Actions;
import 'icons.dart' as Icons;
import 'package:intl/intl.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as timeAgo;

/* ----------------- Splash ------------------ */

void initSplash(BuildContext context) async {
  await Future.delayed(Duration(seconds: 3));
  Navigator.of(context).pushReplacementNamed('/home');
}

Widget buildSplash(BuildContext context) => Scaffold(
      body: Container(
        child: Center(
          child: Text(
            'TODO',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(letterSpacing: 2),
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
        padding: EdgeInsets.all(8),
        child: Consumer<HomeState>(
          rebuild: (context, oldState, newState) async {
            if (newState.pageIndex == oldState.pageIndex)
              return RebuildAction.skip;
            return RebuildAction.rebuild;
          },
          builder: (context, state) => Consumer<HomeState>(
            builder: (context, state) {
              final todos = state.pageIndex == 0
                  ? state.allTodos
                  : state.pageIndex == 1
                      ? state.runningTodos
                      : state.finishedTodos;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    state.pageIndex == 0
                        ? _dashBoard(context, state)
                        : SizedBox(),
                    SizedBox(
                      height: state.pageIndex == 0 ? 16 : 0,
                    ),
                    ...todos.map((_todoTile % context)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 20,
        ),
        mini: true,
        onPressed: () {
          Navigator.of(context)
              .pushNamed('/home/edit', arguments: Todo.create(''));
        },
      ),
      bottomNavigationBar: ProducingConsumer<HomeState>(
        builder: (context, dispatcher, state) => BottomNavigationBar(
          currentIndex: state.pageIndex,
          iconSize: 24,
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
              title: Text('Running'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.completed),
              title: Text('Finished'),
            ),
          ],
        ),
      ),
    );

Widget _dashBoard(BuildContext context, HomeState state) => Card(
      color: Theme.of(context).accentColor,
      child: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${state.finishedTodos.length}/${state.allTodos.length}',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.black87),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                'Finished',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            Divider(
              thickness: 1,
              height: 24,
              color: Colors.black12,
            ),
            Text(
              '${state.runningTodos.length}/${state.allTodos.length}',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.black87),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                'Running',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );

Widget _todoTile(BuildContext context, Todo todo) => ListTile(
      trailing: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: _todoProgressDialog % todo,
          );
        },
        child: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).accentColor,
          child: todo.progress < 100
              ? Text(
                  '${todo.progress.toInt()}',
                  style: TextStyle(fontSize: 12),
                )
              : Icon(
                  Icons.completedAvatar,
                  size: 16,
                ),
        ),
      ),
      title: Text(todo.name),
      subtitle: Text(timeAgo.format(todo.dueDate, enableFromNow: true)),
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

Widget _todoProgressDialog(Todo todo, BuildContext context) {
  final key = GlobalKey<FormBuilderState>();
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        FormBuilder(
          key: key,
          child: FormBuilderSlider(
            attribute: Todo.PROGRESS,
            min: 0,
            max: 100,
            divisions: 100,
            initialValue: todo.progress,
            decoration: InputDecoration(border: InputBorder.none),
          ),
        ),
        Producer<HomeState>(
          builder: (context, dispatcher) => FlatButton(
            child: Text('Update'),
            onPressed: () {
              key.currentState.save();
              final progress = key.currentState.value[Todo.PROGRESS];
              dispatcher.dispatchAsync(
                  Actions.update % todo.copyWith(progress: progress));
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    ),
  );
}

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
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FormBuilderTextField(
          attribute: Todo.NAME,
          decoration: InputDecoration(labelText: 'Todo Name'),
        ),
        SizedBox(height: 8),
        FormBuilderDateTimePicker(
          attribute: Todo.DUE_DATE,
          format: DateFormat('dd MMM yyyy,  h:mm a'),
          decoration: InputDecoration(labelText: 'Due Date'),
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.all(8),
          child: FormBuilderSlider(
            label: 'Progress',
            divisions: 100,
            min: 0,
            max: 100,
            initialValue: todo.progress,
            valueTransformer: (value) => value.toInt(),
            attribute: Todo.PROGRESS,
            decoration: InputDecoration(
                labelText: 'Progress', border: InputBorder.none),
            numberFormat: NumberFormat('###'),
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
