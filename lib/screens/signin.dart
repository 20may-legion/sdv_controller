import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sdv_controller/screens/fbdb.dart';
import 'package:sdv_controller/screens/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapshot/snapshot.dart';

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

FirebaseAuth auth = FirebaseAuth.instance;
DatabaseReference dbref = FirebaseDatabase.instance.reference();

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
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.blueGrey.shade100,
                  child: CircleAvatar(
                    radius: 95,
                    backgroundColor: Colors.grey.shade600,
                    backgroundImage: AssetImage('images/log.png'),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  color: Colors.blueGrey.shade100,
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
                                  color: Colors.black,
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
                Card(
                  color: Colors.blueGrey.shade100,
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
                                  color: Colors.black,
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
                RaisedButton(
                  color: Colors.blueGrey.shade100,
                  onPressed: () async {
                    print(uemail);
                    print(upassword);
                    print(emailvalid(uemail));
                    if (emailvalid(uemail) == false) {
                      alertemail(context);
                    }
                    signIn();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.black, fontSize: 15),
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

  Future alertemail(BuildContext context) async {
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: Text("not valid email!"),
        actions: <Widget>[
          RaisedButton(
            color: Colors.blueGrey.shade100,
            child: Text(
              "Retry",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future alertpassword(BuildContext context) async {
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: Text("wrong password entered"),
        actions: <Widget>[
          RaisedButton(
            color: Colors.blueGrey.shade100,
            child: Text(
              "Retry",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> signIn() async {
    try {
      User user;
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: uemail, password: upassword);
      print('successful');
      user = userCredential.user;
      String cuid = user.uid;
      SharedPreferences pr = await SharedPreferences.getInstance();
      pr.setString('cuid', cuid);
      print('cuid:' + pr.getString('cuid'));
      sleep(const Duration(seconds: 1));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FbDb(
                    cuid: cuid,
                  )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return false;
      } else if (e.code == 'wrong-password') {
        alertpassword(context);
        print('Wrong password provided for that user.');
        return false;
      }
    }
  }

  bool emailvalid(String email) {
    Pattern pattern =
        (r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@utu.ac.in");
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(email)) ? false : true;
  }
}
