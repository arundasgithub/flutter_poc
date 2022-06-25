import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oms/dashboard/home.dart';
import 'package:oms/login/register.dart';
import 'package:oms/login/resetpass.dart';

class myLogin extends StatefulWidget {
  const myLogin({Key? key}) : super(key: key);

  @override
  _myLoginState createState() => _myLoginState();
}

class _myLoginState extends State<myLogin> {
  TextEditingController emailController = TextEditingController();
  /* This is for Creating User and Password Captureing */
  TextEditingController passwordController = TextEditingController();
  //Creating for Loging Function

  void Loginfunction() async {
    String myemail = emailController.text.trim();
    String mypassword = emailController.text.trim();

    if (myemail == "" ||
        myemail == null && mypassword == "" ||
        mypassword == null) {
      log("Please Fill All the Field");
      //This is for Alert box
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Login Failure"),
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
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: myemail, password: mypassword);
        if (userCredential.user != null) {
          print('Log in sucess');
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Login Sucess"),
                  // content: Text("Please Fill all the Details"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                                builder: ((context) => MyHome())));
                      },
                    )
                  ],
                );
              });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Login Failure"),
                  content: Text("Please Give Your Correct User Details"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        emailController.clear();
                        passwordController.clear();
                      },
                    )
                  ],
                );
              });
          print('No user found for that email.');
        }
        // else if (e.code == 'wrong-password') {
        //   print('Wrong password provided for that user.');
        // }
      }
      // UserCredential userCredential = await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(email: email, password: password);
      // // const user = userCredential.user;
      // // if (UserCredential.user != null) {
      // //log("Login sucess");
      // //}

      // log("Login sucess");
      // Navigator.popUntil(context, (route) => route.isFirst);
      // Navigator.pushReplacement(
      //     context, CupertinoPageRoute(builder: ((context) => myHome())));
    }
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
                      'My App',
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
                    top: MediaQuery.of(context).size.height * 0.5,
                    left: 35,
                    right: 35,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          // hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                maximumSize: Size(170.0, 90.0),
                                minimumSize: Size(170.0, 60.0),
                                primary: Color.fromARGB(247, 235, 150, 65),
                                shape: StadiumBorder(),
                              ),
                              onPressed: () {
                                Loginfunction();
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'LOG IN',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Icon(
                                    Icons.lock,
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
                              // Navigator.pushNamed(context, 'register');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const myRegister()));
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 3, 192, 244)),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              //Navigator.pushNamed(context, 'forgot');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const resetPassword()));
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
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
