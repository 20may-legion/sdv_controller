import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart'; //needed for basename
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_messaging/firebase_cloud_messaging.dart';
import 'package:sdv_controller/main.dart';
import 'package:sdv_controller/screens/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final DatabaseReference dbref = FirebaseDatabase.instance.reference();
// ignore: non_constant_identifier_names
bool FanSwitch = true, LightSwitch = true;
final String cuid = auth.currentUser.uid;
final String cemail = auth.currentUser.email;
String cuname, custaffroom, cucabin;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
}

class FbDb extends StatefulWidget {
  @override
  _FbDbState createState() => new _FbDbState();
}

class _FbDbState extends State<FbDb> {
  @override
  Widget build(BuildContext context) {
    /*dbref
        .child('Users')
        .child(cuid)
        .child('name')
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        cuname = snapshot.value;
      });
    });*/
    dbref
        .child('Users')
        .child(cuid)
        .child('staffroom')
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        custaffroom = snapshot.value;
      });
    });
    dbref
        .child('Users')
        .child(cuid)
        .child('cabin no')
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        cucabin = snapshot.value;
      });
    });

    dbref
        .child('Staffroom')
        .child(custaffroom)
        .child(cucabin)
        .child('fan')
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        FanSwitch = snapshot.value;
        //print(snapshot.value);
        //print(FanSwitch);
      });
    });
    dbref
        .child('Staffroom')
        .child(custaffroom)
        .child(cucabin)
        .child('light')
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        LightSwitch = snapshot.value;
      });
    });

    /*MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double h = queryData.size.height;
    double w = queryData.size.width;*/
    return new Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("hello"),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.blueGrey.shade100,
                child: Row(
                  children: [
                    Center(
                      child: FlatButton.icon(
                        onPressed: () async {
                          logout(context);
                          final pr = await SharedPreferences.getInstance();
                          pr.remove('userId');
                          print("logout");
                        },
                        icon: Icon(Icons.check),
                        label: Text("logout"),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey.shade100,
        title: new Text(
          "hello",
          //cuname,
          style: TextStyle(color: Colors.black),
        ), //todo add name from database
      ),
      body: SingleChildScrollView(
        child: Center(
          child: new Container(
              padding: new EdgeInsets.all(16.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image(
                    image: AssetImage('images/fbdb$cucabin.png'),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Card(
                        color: Colors.blueGrey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image(
                                image: AssetImage('images/fan.png'),
                                height: 100,
                              ),
                              NeumorphicSwitch(
                                value: FanSwitch,
                                style: NeumorphicSwitchStyle(
                                    inactiveTrackColor: Colors.pinkAccent,
                                    activeTrackColor: Colors
                                        .greenAccent), //todo add secondary color
                                onChanged: toggleFan,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Card(
                        color: Colors.blueGrey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image(
                                image: AssetImage('images/lamp.png'),
                                height: 100,
                              ),
                              NeumorphicSwitch(
                                value: LightSwitch,
                                style: NeumorphicSwitchStyle(
                                    inactiveTrackColor: Colors.pinkAccent,
                                    activeTrackColor: Colors
                                        .greenAccent), //todo add secondary color
                                onChanged: toggleLight,
                              ),
                            ],
                          ),
                        ),
                      ),
                      RaisedButton(onPressed: () {
                        //print(h);
                        //print(w);
                      })
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void toggleFan(bool value) {
    if (FanSwitch == false) {
      setState(() {
        FanSwitch = true;
      });
      print('Fan is ON');
      dbref
          .child('Staffroom')
          .child(custaffroom)
          .child(cucabin)
          .update({'fan': FanSwitch});
    } else {
      setState(() {
        FanSwitch = false;
      });
      print('Fan is OFF');
      print(custaffroom);
      print(cucabin);
      dbref
          .child('Staffroom')
          .child(custaffroom)
          .child(cucabin)
          .update({'fan': FanSwitch});
    }
  }

  void toggleLight(bool value) {
    if (LightSwitch == false) {
      setState(() {
        LightSwitch = true;
      });
      print('Light is ON');
      dbref
          .child('Staffroom')
          .child(custaffroom)
          .child(cucabin)
          .update({'light': LightSwitch});
    } else {
      setState(() {
        LightSwitch = false;
      });
      print('Light is OFF');
      dbref
          .child('Staffroom')
          .child(custaffroom)
          .child(cucabin)
          .update({'light': LightSwitch});
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      auth.signOut();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Signin()));
    } catch (e) {
      //print(e.toString());
    }
  }
}
