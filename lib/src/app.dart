import 'package:flutter/material.dart';
import 'package:flutter_utils/arch.dart';

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',
      routes: {
        '/': (context) => FunctionalWidget(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
