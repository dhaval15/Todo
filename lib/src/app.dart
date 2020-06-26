import 'package:flutter/material.dart';
import 'package:flutter_utils/arch.dart';
import 'package:flutter_utils/database.dart';
import 'models.dart';
import 'states.dart';
import 'ui.dart' as UI;

class TodoApp extends StatelessWidget {
  final Database database;
  final StoreRef storeRef;

  const TodoApp({Key key, this.database, this.storeRef}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Provider(
      providers: {
        HomeState: () => HomeState(
              pageIndex: 0,
              client: database,
              todoStore: storeRef,
              todos: Map(),
            ),
      },
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.dark,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => FunctionalWidget(
                init: UI.initSplash,
                build: UI.buildSplash,
              ),
          '/home': (context) => FunctionalWidget(
                init: UI.initHome,
                build: UI.buildHome,
              ),
          '/home/edit': (context) => FunctionalWidget(
                build: UI.buildEditTodo,
              ),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
