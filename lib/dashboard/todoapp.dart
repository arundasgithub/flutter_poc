import 'package:flutter/material.dart';

void main() => runApp(todo());

class todo extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To do List',
      home: Text("Todo"),
    );
  }
}
