import 'package:flutter/foundation.dart';

class Todo {
  late String id;
  late String title;
  late String description;
  final DateTime _dateTime = DateTime.now();

  TodoMap() {
    var mapping = Map<String, dynamic>();
    mapping["todoID"] = id;
    mapping["todoTitle"] = title;
    mapping["todoDesc"] = description;
    mapping["todoDate"] = _dateTime;
    return mapping;
  }
}
