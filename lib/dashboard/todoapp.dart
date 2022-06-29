import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oms/dashboard/home.dart';
import 'package:oms/operations/deleteTodo.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<String> _todoList = <String>[];
  // List _todolist = List.empty();
  String id = "";
  String title = "";
  String description = "";
  DateTime _dateTime = DateTime.now();
  // text field
  final TextEditingController _titleFieldController = TextEditingController();
  final TextEditingController _descriptionFieldController =
      TextEditingController();
  var _todoDateController = TextEditingController();

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

  createTodo() {
    DocumentReference documentReference =
        // FirebaseFirestore.instance.collection("MyTodos").doc(title);
        FirebaseFirestore.instance.collection("MyTodos").doc(id);

    // Map<String,DateTime> todoList = {
    var todoList = {
      "todoID": id,
      "todoTitle": title,
      "todoDesc": description,
      "todoDate": _dateTime,
    };

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));
  }

  editTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);
    var todoList = {
      "todoID": id,
      "todoTitle": title,
      "todoDesc": description,
      "todoDate": _dateTime,
    };
    documentReference
        .update(todoList)
        .whenComplete(() => print("Data Upadated successfully"));
  }

  delete(item) {
    deleteTodo(item);
  }

  _showFormDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text("Add Todo"),
            content: SizedBox(
              height: 500,
              width: 200,
              child: Column(children: [
                TextField(
                  decoration: const InputDecoration(labelText: ('ID')),
                  onChanged: (String value) {
                    id = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: ('Title')),
                  onChanged: (String value) {
                    title = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: ('Description')),
                  onChanged: (String value) {
                    description = value;
                  },
                ),
                TextField(
                    controller: _todoDateController,
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
                    setState(() {
                      // todos.add(title);
                      createTodo();
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text("Add"))
            ],
          );
        });
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
                  decoration: InputDecoration(
                      labelText: ('ID'),
                      hintText: ((documentSnapshot != null)
                          ? (documentSnapshot["todoID"])
                          : "")),
                  onChanged: (String value) {
                    id = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: ('Title'),
                      hintText: ((documentSnapshot != null)
                          ? (documentSnapshot["todoTitle"])
                          : "")),
                  onChanged: (String value) {
                    title = value;
                  },
                ),
                TextField(
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
                    controller: _todoDateController,
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
                    setState(() {
                      // todos.add(title);
                      // editTodo((documentSnapshot != null)
                      //     ? (documentSnapshot["todoTitle"])
                      //     : "");
                      editTodo((documentSnapshot != null)
                          ? (documentSnapshot["todoID"])
                          : "");
                    });
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
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      // body: ListView(children: _getItems()),
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
                          leading: Text((documentSnapshot != null)
                              ? (documentSnapshot["todoID"])
                              : ""),
                          title: Text((documentSnapshot != null)
                              ? (documentSnapshot["todoTitle"])
                              : ""),
                          subtitle: Text((documentSnapshot != null)
                              ? ((documentSnapshot["todoDesc"] != null)
                                  ? documentSnapshot["todoDesc"]
                                  : "")
                              : ""),
                          // subtitle: $_todoDateController.text,
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                            children: <Widget>[
                              // IconButton(
                              //   icon: const Icon(Icons.edit),
                              //   color: Colors.red,
                              //   onPressed: () {
                              //     setState(() {
                              //       _editFormDialog(context, snapshot, index);
                              //     });
                              //   },
                              // ),
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
              padding: const EdgeInsets.only(left: 120.0),
              iconSize: 40,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.today_outlined,
                  color: Color.fromARGB(247, 235, 150, 65)),
              padding: const EdgeInsets.only(left: 130.0),
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
        onPressed: () {
          _showFormDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
