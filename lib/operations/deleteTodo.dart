import 'package:cloud_firestore/cloud_firestore.dart';

deleteTodo(item) {
  DocumentReference documentReference =
      FirebaseFirestore.instance.collection("MyTodos").doc(item);

  documentReference.delete().whenComplete(() => print("deleted successfully"));
}
