import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oms/dashboard/home.dart';
import 'package:oms/welcompage.dart';
import 'package:oms/login/login.dart';
import 'package:oms/login/register.dart';
import 'package:oms/login/resetpass.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'Welcom',
      title: 'POC',
      routes: {
        'Welcom': (context) => Welcom(),
        'login': (context) => myLogin(),
        'register': (context) => myRegister(),
        'forgot': (context) => resetPassword(),
        'home': (context) => MyHome(),
      },
    ),
  );
  // runApp(MyApp());

  // Class MyApp extends StatelessWidget{
  //   const MyApp({key ? key}):super(Key:key);
  //   @override
  //   Widget @override
  //   Widget build(BuildContext context) {
  //     home:MyLogin(),
  //     return ;
  //   }
  // }
}
