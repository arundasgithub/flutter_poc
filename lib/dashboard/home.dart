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
                icon: const Icon(Icons.search_outlined),
                padding: const EdgeInsets.only(left: 120.0),
                iconSize: 40,
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.today_outlined),
                padding: const EdgeInsets.only(left: 130.0),
                iconSize: 40,
                onPressed: () {
                  print("Arun");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TodoListScreen()));
                },
              )
            ],
          ),
        ));
  }
}
