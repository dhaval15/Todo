import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'src/app.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Database database = await databaseFactoryIo
      .openDatabase(join(dir.path, 'todos.db'), version: 1);
  StoreRef<String, dynamic> todoStore = stringMapStoreFactory.store('todos');
  runApp(TodoApp(
    database: database,
    storeRef: todoStore,
  ));
}
