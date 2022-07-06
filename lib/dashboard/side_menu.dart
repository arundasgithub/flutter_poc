import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../login/login.dart';

class NavDrawer extends StatelessWidget {
  final email = FirebaseAuth.instance.currentUser!.email;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    void Logout() async {
      // final user = FirebaseAuth.instance.currentUser;
      User? user = FirebaseAuth.instance.currentUser;
      //var name = FirebaseFirestore.instance.collection("User").snapshots();
      print("Test Arun");
      //print(name);

      await FirebaseAuth.instance.signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: ((context) => myLogin())));
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // DrawerHeader(
          //   child: Text(
          //     'Welcome',
          //     style: TextStyle(color: Colors.white, fontSize: 25),
          //   ),
          //   decoration: BoxDecoration(
          //     color: Colors.orange,
          //     //image:DecorationImage(fit: BoxFit.fill, image: NetworkImage(''))
          //   ),
          // ),
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.lightBlue,
              backgroundImage: AssetImage(
                'assets/profile.jpg',
              ),
            ),
            accountName: Text(email!),
            accountEmail: Text(''),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
            ),
          ),
          // ListTile(
          //   leading: Icon(Icons.input),
          //   //title: Text('Welcome'),
          //   title: Text(user),
          //   onTap: () => {},
          // ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Logout()},
          ),
        ],
      ),
    );
  }
}
