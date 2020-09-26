import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sdv_controller/screens/signin.dart';
import 'package:snapshot/snapshot.dart';
import 'package:sdv_controller/screens/fbdb.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseDatabase database = FirebaseDatabase();
final DatabaseReference dbref = FirebaseDatabase.instance.reference();

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => new _SignupState();
}

class _SignupState extends State<Signup> {
  String uemail = '', upassword = '', uname = '', ustaffroom = 'CE';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SingleChildScrollView(
        child: new Container(
          padding: new EdgeInsets.all(8),
          child: new Center(
            child: new Column(
              children: <Widget>[
                SizedBox(height: 25),
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
                            onSubmitted: (input) => uname = input,
                            onChanged: (input) => uname = input,
                            decoration: InputDecoration(
                                hintText: 'Enter your name',
                                icon: new Icon(Icons.person,
                                    size: 30, color: textColor(context))),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
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
                        Icon(
                          Icons.room,
                          size: 30,
                          color: textColor(context),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        DropdownButton<String>(
                          value: ustaffroom,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 22,
                          iconEnabledColor: Colors.white,
                          style: TextStyle(color: Colors.black),
                          underline: Container(
                            height: 1,
                            color: Colors.black,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              ustaffroom = newValue;
                            });
                          },
                          items: <String>['CE', 'IT', 'MECH', 'AUTO']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
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
                                  size: 30,
                                  color: textColor(context),
                                )),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
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
                            //todo :send name to database
                            decoration: InputDecoration(
                                hintText: 'Enter password',
                                icon: new Icon(
                                  Icons.lock,
                                  size: 30,
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
                SizedBox(height: 10),
                NeumorphicButton(
                  style: NeumorphicStyle(
                      depth: NeumorphicTheme.of(context).current.depth,
                      intensity: NeumorphicTheme.of(context).current.intensity,
                      color: iconsColor(context) //customize color here
                      ),
                  onPressed: () {
                    signUp();
                    print(uemail);
                    print(upassword);
                    print(uname);
                    print(ustaffroom);
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(color: textColor(context), fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: uemail, password: upassword);
      print('successful');
      final String cuid = userCredential.user.uid;

      dbref.child('Staffroom').child(ustaffroom).child(cuid).set({'bulb': '0'});
      dbref
          .child('Users')
          .child(cuid)
          .set({'email': uemail, 'name': uname, 'staffroom': ustaffroom});
      final name = new MaterialPageRoute(
        builder: (BuildContext context) => new FbDb(name: uname),
      );

      Navigator.of(context).push(name);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
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
