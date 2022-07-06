import 'package:flutter/material.dart';
import 'package:oms/dashboard/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:oms/operations/deleteTodo.dart';
import 'package:intl/intl.dart';
import 'package:oms/dashboard/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'delete_screen.dart';
import 'reminder_screen.dart';

void main() => runApp(TodoList2());

class TodoList2 extends StatelessWidget {
  const TodoList2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: TodoListPage2(),
    );
  }
}

class TodoListPage2 extends StatefulWidget {
  const TodoListPage2({Key? key}) : super(key: key);

  // final String title;

  @override
  State<TodoListPage2> createState() => _TodoListState2();
}

class _TodoListState2 extends State<TodoListPage2> {
  final List<String> _todoList = <String>[];

  String id = "";
  String title = "";
  String description = "";
  String reminderValue = "";
  String timeValue = "";

  //bool _validate = false;
  bool _validateTile = false;
  bool _validateDesc = false;
  bool _validateDate = false;
  bool _validateTime = false;

  DateTime _dateTime = DateTime.now();
  DateTime now = DateTime.now();
  int _groupValue = -1;
  var _todoDateController = TextEditingController();
  var _todoTimeController = TextEditingController();

  TimeOfDay time = TimeOfDay.now();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _desController = new TextEditingController();

  // TextEditingController _datetroller = new TextEditingController();

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
        //_datetroller.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  editTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);
    var todoList = {
      "todoTitle": title,
      "todoDesc": description,
      "todoDate": _todoDateController.text,
      "todotime": time,
    };
    documentReference
        .update(todoList)
        .whenComplete(() => print("Data Upadated successfully"));
  }

  delete(item) {
    deleteTodo(item);
  }

  _selectedTodoTime(BuildContext context) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (newTime != null) {
      setState(() {
        time = newTime;
        _todoTimeController.text = newTime.format(context);
      });
    }
  }

  _editFormDialog(BuildContext context, snapshot, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          QueryDocumentSnapshot<Object?>? documentSnapshot =
              snapshot.data?.docs[index];

          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Edit Todo"),
            content: SizedBox(
              height: 550,
              width: 200,
              child: Column(children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    errorText: _validateTile ? "Value Can\'t Be Empty" : null,
                  ),
                  onChanged: (String value) {
                    title = value;
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _desController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    errorText: _validateDesc ? "Value Can\'t Be Empty" : null,
                  ),
                  onChanged: (String value) {
                    description = value;
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                    onChanged: (String value) {
                      _todoDateController.text = value;
                    },
                    controller: _todoDateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      errorText: _validateDate ? "Value Can\'t Be Empty" : null,
                      prefixIcon: InkWell(
                        onTap: () {
                          _selectedTodoDate(context);
                        },
                        child: const Icon(Icons.calendar_today),
                      ),
                    )),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                    onChanged: (String value) {
                      _todoTimeController.text = value;
                    },
                    controller: _todoTimeController,
                    decoration: InputDecoration(
                      labelText: 'Time',
                      errorText: _validateTime ? "Value Can\'t Be Empty" : null,
                      prefixIcon: InkWell(
                        onTap: () {
                          _selectedTodoTime(context);
                        },
                        child: const Icon(Icons.lock_clock),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
              ]),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    setState(() {
                      editTodo((documentSnapshot != null)
                          ? (documentSnapshot["todoID"])
                          : "");
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(fontSize: 19),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: NavDrawer(),
      appBar: AppBar(title: const Text('Home'), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.black,
          onPressed: () {
            setState(() {
              Navigator.push(context,
                  CupertinoPageRoute(builder: ((context) => DeleteScreen())));
              /* delete((documentSnapshot != null)
                  ? (documentSnapshot["todoID"])
                  : "");*/
            });
          },
        ),
      ]),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot<Object?>? documentSnapshot =
                      snapshot.data?.docs[index];
/*

                  var date = snapshot.data?.docs[index]['todoDate'];
                  var time = snapshot.data?.docs[index]['todotime'];
*/
/*
                  var todayDate = DateFormat("dd-MM-yyyy").format(now);
                  String date = snapshot.data?.docs[index]['todoDate'];
                  print(todayDate + " =====ss " + date); //30-06-2021


                  DateTime todayDate1 = DateFormat("dd-MM-yyyy").parse(date);
                  final bool isExpired = todayDate1.isBefore(now);

                  print(todayDate + " =====ss " + date + isExpired.toString());*/ //30-06-2021

                  /*   final now = DateTime.now();
                  final expirationDate = DateTime(date);

                  final bool isExpired = expirationDate.isBefore(now);
*/
                  return Dismissible(
                      key: Key(index.toString()),
                      child: Card(
                        elevation: 4,
                        child: ListTile(
                          title: Text((documentSnapshot != null)
                              ? (documentSnapshot["todoTitle"])
                              : ""),
                          subtitle: Text((documentSnapshot != null)
                              ? ((documentSnapshot["todoDesc"] != null)
                                  ? documentSnapshot["todoDesc"]
                                  : "")
                              : ""),
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                            children: <Widget>[
                              //if (isExpired) const Text("Passed ") else const Text("Upcoming")

                              /* Text((documentSnapshot != null)
                                  ? ((documentSnapshot["todoDate"] != null)
                                  ? documentSnapshot["todoDate"]
                                  : "")
                                  : ""),
                              Text((documentSnapshot != null)
                                  ? ((documentSnapshot["todotime"] != null)
                                  ? documentSnapshot["todotime"]
                                  : "")
                                  : ""),*/

                              /*    IconButton(
                                icon: const Icon(Icons.edit,size: 5,),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                     delete((documentSnapshot != null)
                                        ? (documentSnapshot["todoID"])
                                        : "");
                                  });
                                },
                              ),*/
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              _titleController.text =
                                  documentSnapshot!["todoTitle"];
                              _desController.text =
                                  documentSnapshot["todoDesc"];
                              _todoDateController.text =
                                  documentSnapshot["todoDate"];
                              _todoTimeController.text =
                                  documentSnapshot["todotime"];

                              _editFormDialog(context, snapshot, index);
                            });
                          },
                        ),
                      ));
                });
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.red,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              CupertinoPageRoute(builder: ((context) => ReminderScreen())));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _myRadioButton(
      {required String title,
      required int value,
      required Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: (value) {
        _groupValue != value;
      },
      title: Text(title),
    );
  }
}
