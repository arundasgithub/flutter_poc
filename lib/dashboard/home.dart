import 'package:flutter/material.dart';
import 'package:oms/dashboard/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:oms/dashboard/todoapp.dart';

void main() => runApp(MyHome());

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
          child: Text('Your Dashbord is Here'),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50.0,
            child: Row(children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  print("Arun");
                },
              ),
              IconButton(
                icon: Icon(Icons.search_outlined),
                onPressed: () {
                  print("Arun");
                },
              ),
              IconButton(
                icon: Icon(Icons.today_outlined),
                onPressed: () {
                  print("Arun");
                  Navigator.push(context,
                      CupertinoPageRoute(builder: ((context) => todo())));
                },
              )
            ]),
          ),
        ));
  }
}
