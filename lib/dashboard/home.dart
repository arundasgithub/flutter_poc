import 'package:flutter/material.dart';
import 'package:oms/dashboard/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:oms/dashboard/todo_app.dart';

void main() => runApp(MyHome());

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      debugShowCheckedModeBanner: false,
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
          title: const Text('Home'),
        ),
        body: const Center(
          child: Text('Your Dashbord is Here'),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home,
                    color: Color.fromARGB(247, 235, 150, 65)),
                padding: const EdgeInsets.only(left: 30.0),
                iconSize: 40,
                onPressed: () {},
              ),
              IconButton(
                padding: const EdgeInsets.only(left: 100.0),
                icon: const Icon(Icons.search_outlined),
                iconSize: 40,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.today_outlined),
                padding: const EdgeInsets.only(left: 110.0),
                iconSize: 40,
                onPressed: () {
                  print("Todo List Page");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TodoList()));
                },
              )
            ],
          ),
        ));
  }
}
