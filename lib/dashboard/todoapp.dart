import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:oms/dashboard/home.dart';
import 'package:intl/intl.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<String> _todoList = <String>[];
  // List _todolist = List.empty();
  String title = "";
  String description = "";
  // text field
  final TextEditingController _titleFieldController = TextEditingController();
  final TextEditingController _descriptionFieldController =
      TextEditingController();
  var _todoDateController = TextEditingController();
  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      // body: ListView(children: _getItems()),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: _todoList.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(index.toString()),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(_todoList[index]),
                    subtitle: const Text("description"),
                    //:const Text("hiii"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          _todoList.removeAt(index);
                        });
                      },
                    ),
                  ),
                ));
          }),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              padding: const EdgeInsets.only(left: 30.0),
              iconSize: 40,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyHome()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.search_outlined),
              padding: const EdgeInsets.only(left: 100.0),
              iconSize: 40,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.today_outlined,
                  color: Color.fromARGB(247, 235, 150, 65)),
              padding: const EdgeInsets.only(left: 110.0),
              iconSize: 40,
              onPressed: () {
                print("Arun");
              },
            )
          ],
        ),
      ),
      // add items to the to-do list
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: Icon(Icons.add)),
    );
  }

  void _addTodoItem(String title) {
    //  a set state will notify the app that the state has changed
    setState(() {
      _todoList.add(title);
      // _todoList.add(description);
      //_todoList.add(date);
    });
    _titleFieldController.clear();
    //  _descriptionFieldController.clear();
    //  _todoDateController.clear();
  }

  Widget _buildTodoItem(String title) {
    return ListTile(title: Text(title));
  }
  // Widget _buildTodoItem(String description) {
  //   return ListTile(title: Text(description));
  // }

  Future<Future> _displayDialog(BuildContext context) async {
    // alter the app state to show a dialog
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: SizedBox(
              height: 300,
              width: 200,
              child: Column(children: [
                TextField(
                  controller: _titleFieldController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _descriptionFieldController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                    controller: _todoDateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: InkWell(
                        onTap: () {
                          _selectedTodoDate(context);
                        },
                        child: Icon(Icons.calendar_today),
                      ),
                    )),
                //  ),
              ]),
            ),
            actions: <Widget>[
              // add button
              RaisedButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(
                    _titleFieldController.text,
                  );
                },
              ),
              // cancel button
              RaisedButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  // iterates through our todo list titles.
//   List<Widget> _getItems() {
//     final List<Widget> _todoWidgets = <Widget>[];
//     for (String title in _todoList) {
//       _todoWidgets.add(_buildTodoItem(title));
//     }
//     return _todoWidgets;
//   }
}
