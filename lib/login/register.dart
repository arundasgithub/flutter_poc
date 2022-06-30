import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oms/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:oms/login/resetpass.dart';

class myRegister extends StatefulWidget {
  const myRegister({Key? key}) : super(key: key);

  @override
  _myRegisterState createState() => _myRegisterState();
}

class _myRegisterState extends State<myRegister> {
  //TextEditingController usernameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void createAccount() async {
    String user = userNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (user == "" || email == "" || password == "") {
      log("Please Fill all the Details");
      errorRegister();
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        DocumentReference documentReference =
            FirebaseFirestore.instance.collection("User").doc(user);

        var todoList = {"user": user, "email": email, "password": password};
        documentReference
            .set(todoList)
            .whenComplete(() => print("Data stored successfully"));
        log("User Created");
        jumptoLogin();
      } on FirebaseAuthException catch (e) {
        print("arun");
        print(e.code);
        if (e.code != "") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text(e.code),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        } else {
          jumptoLogin();
        }
      }
    }
  }

  void errorRegister() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Register Failure"),
            content: Text("Please Fill all the Details"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void jumptoLogin() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("User Sucessfully Created"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  //Navigator.pushNamed(context, 'login');
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => myLogin()));
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/login.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: 60.0,
                    ),
                    child: Text(
                      'Register',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3,
                    left: 35,
                    right: 35,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              )),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                maximumSize: const Size(170.0, 90.0),
                                minimumSize: const Size(170.0, 60.0),
                                primary: Color.fromARGB(247, 235, 150, 65),
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () {
                                createAccount();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('REGISTER'),
                                  Icon(
                                    Icons.content_paste_rounded,
                                    color: Color.fromARGB(255, 241, 34, 19),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => myLogin()));
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  height: 1,
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 3, 192, 244)),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => resetPassword()));
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                  height: 1,
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 3, 192, 244)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
