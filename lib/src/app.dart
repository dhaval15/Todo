import 'package:flutter/material.dart';
import 'package:flutter_utils/arch.dart';
import 'ui.dart' as UI;

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => FunctionalWidget(
              init: UI.initSplash,
              build: UI.buildSplash,
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
