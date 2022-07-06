import 'package:flutter/material.dart';
import 'package:oms/dashboard/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:oms/operations/deleteTodo.dart';
import 'package:intl/intl.dart';
import 'package:oms/dashboard/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'reminder_screen.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({Key? key}) : super(key: key);

  // final String title;

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  final List<String> _todoList = <String>[];

  String id = "";
  String title = "";
  String description = "";
  String reminderValue = "";
  String timeValue = "";

  DateTime _dateTime = DateTime.now();
  DateTime now = DateTime.now();
  int _groupValue = -1;
  var _todoDateController = TextEditingController();
  final _todoTimeController = TextEditingController();
  TimeOfDay time = TimeOfDay.now();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _desController = new TextEditingController();
  TextEditingController _datetroller = new TextEditingController();

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
        _datetroller.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
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
              height: 500,
              width: 200,
              child: Column(children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      labelText: ('Title'), hintText: ("Title")),
                  onChanged: (String value) {
                    title = value;
                  },
                ),
                TextField(
                  controller: _desController,
                  decoration: InputDecoration(
                      labelText: ('Description'),
                      hintText: ((documentSnapshot != null)
                          ? ((documentSnapshot["todoDesc"] != null)
                              ? documentSnapshot["todoDesc"]
                              : "")
                          : "")),
                  onChanged: (String value) {
                    description = value;
                  },
                ),
                TextField(
                    controller: _datetroller,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: InkWell(
                        onTap: () {
                          _selectedTodoDate(context);
                        },
                        child: const Icon(Icons.calendar_today),
                      ),
                    )),
              ]),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text("Update"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete ToDo'), actions: <Widget>[]),
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
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    delete((documentSnapshot != null)
                                        ? (documentSnapshot["todoID"])
                                        : "");
                                  });
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              _titleController.text =
                                  documentSnapshot!["todoTitle"];
                              _desController.text =
                                  documentSnapshot!["todoDesc"];
                              //  _datetroller.text =documentSnapshot!["todoDate"];
                              //  _datetroller.text = documentSnapshot!["todoTitle"];
                              //_editFormDialog(context, snapshot, index);
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
    );
  }
}
