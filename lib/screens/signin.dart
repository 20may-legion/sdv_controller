import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sdv_controller/screens/fbdb.dart';
import 'package:sdv_controller/screens/signin.dart';
import 'package:snapshot/snapshot.dart';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:clay_containers/clay_containers.dart';

Future<void> main() async {
  final FirebaseApp app = await Firebase.initializeApp(
      name: 'db2',
      options: FirebaseOptions(
        appId: '1:72006686107:android:32667c0578ae8c845ffd3e',
        apiKey: 'AIzaSyAXVtNHpga8iZ3aq2xQt5wU9GK3ATCpp6g',
        projectId: 'sdv-controller',
        messagingSenderId: '72006686107',
        databaseURL: 'https://sdv-controller.firebaseio.com/',
      ));
}

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => new _SigninState();
}

class _SigninState extends State<Signin> {
  String uemail = '', upassword = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SingleChildScrollView(
        child: new Container(
          padding: new EdgeInsets.all(16),
          child: new Center(
            child: new Column(
              children: <Widget>[
                SizedBox(height: 100),
                Center(
                  child: Text(
                    'Sign in to SDV and continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      color: textColor(context),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: iconsColor(context),
                  child: CircleAvatar(
                    radius: 95,
                    backgroundColor: Colors.grey.shade600,
                    backgroundImage: AssetImage('images/log.png'),
                  ),
                ),
                SizedBox(height: 20),
                Neumorphic(
                  style: NeumorphicStyle(
                      intensity: 1,
                      depth: -3, //customize depth here
                      color: iconsColor(context) //customize color here
                      ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onSubmitted: (input) => uemail = input,
                            onChanged: (input) => uemail = input,
                            decoration: InputDecoration(
                                hintText: 'Enter UTU email',
                                icon: new Icon(
                                  Icons.mail,
                                  color: textColor(context),
                                )),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Neumorphic(
                  style: NeumorphicStyle(
                      intensity: 1,
                      depth: -3, //customize depth here
                      color: iconsColor(context) //customize color here
                      ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onSubmitted: (input) => upassword = input,
                            onChanged: (input) => upassword = input,
                            decoration: InputDecoration(
                                hintText: 'Enter password',
                                icon: new Icon(
                                  Icons.lock,
                                  color: textColor(context),
                                )),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                NeumorphicButton(
                  style: NeumorphicStyle(
                      depth: NeumorphicTheme.of(context).current.depth,
                      intensity: NeumorphicTheme.of(context).current.intensity,
                      color: iconsColor(context) //customize color here
                      ),
                  onPressed: () {
                    print(uemail);
                    print(upassword);
                    signIn();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: textColor(context), fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: uemail, password: upassword);
      print('successful');

      Navigator.of(context).pushNamed('/FbDb');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return false;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return false;
      }
    }
  }

  Color iconsColor(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    if (theme.isUsingDark) {
      return theme.current.accentColor;
    } else {
      return theme.current.accentColor;
    }
  }

  Color textColor(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
