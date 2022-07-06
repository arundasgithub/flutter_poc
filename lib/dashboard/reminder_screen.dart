import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oms/dashboard/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:oms/dashboard/todo_app2.dart';
import 'package:oms/operations/deleteTodo.dart';
import 'package:intl/intl.dart';
import 'package:oms/dashboard/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  // final String title;

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final List<String> _todoList = <String>[];

  String id = "";
  String title = "";
  String description = "";
  String reminderValue = "";
  String timeValue = "";
  TextEditingController emailController = TextEditingController();

  DateTime _dateTime = DateTime.now();
  DateTime now = DateTime.now();
  int _groupValue = -1;

  //bool _validate = false;
  bool _validateTile = false;
  bool _validateDesc = false;
  bool _validateDate = false;
  bool _validateTime = false;

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

  createTodo(String time) {
    DateTime now = DateTime.now();
    var HardId = (now.year.toString() +
        now.hour.toString() +
        now.minute.toString() +
        now.second.toString());
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(HardId);

    var todoList = {
      "todoID": HardId,
      "todoTitle": title,
      "todoDesc": description,
      "todoDate": _todoDateController.text,
      "todoReminder": reminderValue,
      "todotime": time,
    };

    documentReference
        .set(todoList)
        .whenComplete(() => print("Data stored successfully"));

    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: ((context) => TodoList2())));
  }

  editTodo(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(item);
    var todoList = {
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
                  decoration: const InputDecoration(
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
                    setState(() {
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.hasData || snapshot.data != null) {
            return Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              child: Column(children: [
                TextField(
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
                  decoration: InputDecoration(
                    labelText: 'Description',
                    errorText: _validateDesc ? "Value Can\'t Be Empty" : null,
                  ),
                  onChanged: (String value) {
                    description = value;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
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
                  height: 15,
                ),
                TextField(
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
                  height: 25,
                ),
                Column(
                  children: <Widget>[
                    const Text(
                      "Reminder Frequency",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RadioListTile(
                      value: 0,
                      groupValue: _groupValue,
                      title: const Text("Daily"),
                      onChanged: (newValue) {
                        setState(() {
                          _groupValue = 0;
                          reminderValue = "Weekly";
                        });
                      },
                      activeColor: Colors.red,
                      selected: false,
                    ),
                    RadioListTile(
                      value: 1,
                      groupValue: _groupValue,
                      title: const Text("Weekly"),
                      onChanged: (newValue) {
                        setState(() {
                          _groupValue = 1;

                          reminderValue = "Weekly";
                        });
                      },
                      activeColor: Colors.red,
                      selected: false,
                    ),
                    RadioListTile(
                      value: 2,
                      groupValue: _groupValue,
                      title: const Text("Monthly"),
                      onChanged: (newValue) {
                        setState(() {
                          _groupValue = 2;
                          reminderValue = "Monthly";
                        });
                      },
                      activeColor: Colors.red,
                      selected: false,
                    ),
                    RadioListTile(
                      value: 3,
                      groupValue: _groupValue,
                      title: const Text("Yearly"),
                      onChanged: (newValue) {
                        setState(() {
                          _groupValue = 3;
                          reminderValue = "Yearly";
                        });
                      },
                      activeColor: Colors.red,
                      selected: false,
                    ),
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      maximumSize: Size(170.0, 90.0),
                      minimumSize: Size(170.0, 60.0),
                      primary: Color.fromARGB(247, 235, 150, 65),
                      shape: StadiumBorder(),
                    ),
                    onPressed: () {
                      setState(() {
                        if (title.isEmpty) {
                          _validateTile = true;
                        } else if (description.isEmpty) {
                          _validateTile = false;
                          _validateDesc = true;
                        } else if (_todoDateController.text.isEmpty) {
                          _validateTile = false;
                          _validateDesc = false;
                          _validateDate = true;
                        } else if (_todoTimeController.text.isEmpty) {
                          _validateTile = false;
                          _validateDesc = false;
                          _validateDate = false;
                          _validateTime = true;
                        } else {
                          _validateTile = false;
                          _validateDesc = false;
                          _validateDate = false;
                          _validateTime = false;
                          createTodo(_todoTimeController.text);
                        }
                      });

                      /*setState(() {
                       _todoTimeController.text.isEmpty
                           ? _validate = true
                           : _validate = false;

                       createTodo(_todoTimeController.text);
                     });*/
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Add',
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Icons.add_to_photos_outlined,
                          color: Color.fromARGB(255, 241, 34, 19),
                        ),
                      ],
                    )),
              ]),
            );
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
