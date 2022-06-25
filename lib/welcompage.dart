import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:oms/login/login.dart';

void main() => runApp(Welcom());

class Welcom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: WelcomPage(),
    );
  }
}

class WelcomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/login.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: 80.0,
                    ),
                    child: Text(
                      'Welcome to the best ToDo baby !!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            letterSpacing: 3,
                            fontSize: 20,
                            wordSpacing: 2,
                          ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 80.0,
                    ),

                    // child: Text(
                    //   'Welcom \n To ToDo Application',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     color: Color.fromARGB(255, 203, 147, 51),
                    //     fontSize: 40.0,
                    //   ),
                    // ),
                    // child: Text(
                    //   'Welcome to the best Task manager baby !!',
                    //   textAlign: TextAlign.center,
                    //   style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    //         letterSpacing: 3,
                    //         fontSize: 12,
                    //         wordSpacing: 2,
                    //       ),
                    // ),

                    child: RaisedButton(
                      onPressed: () => {
                        print("amitha"),
                        //do something
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => myLogin())),
                      },
                      child: new Text('Next'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
