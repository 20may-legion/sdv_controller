import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart'; //needed for basename
import 'package:firebase_auth/firebase_auth.dart';

//final dbref = FirebaseDatabase.instance.reference().child('email');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(new MaterialApp(
    home: FbDb(),
  ));
}

class FbDb extends StatefulWidget {
  final String name;

  FbDb({this.name, Key key}) : super(key: key);
  @override
  _FbDbState createState() => new _FbDbState();
}

class _FbDbState extends State<FbDb> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase database = FirebaseDatabase();
  final DatabaseReference dbref = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    final String cuid = auth.currentUser.uid;
    final String cemail = auth.currentUser.email;
    //final String cuname = todo add user name from database

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('hello '),
      ),
      body: new Container(
          padding: new EdgeInsets.all(32.0),
          child: new Center(
            child: new Column(
              children: <Widget>[
                //new Text(cuname),
                new RaisedButton(
                  onPressed: () {
                    // Navigator.of(context).pushNamed('/Third');
                  },
                  child: new Text('Next'),
                ),
                new RaisedButton(
                  onPressed: () {
                    write();
                    //read();
                    //Navigator.of(context).pushNamed('/Home');\
                  },
                  child: new Text('Back'),
                )
              ],
            ),
          )),
    );
  }

  void write() {
    dbref.set({'denish': 'yo'});
  }

/*
  void read() {
    dbref.once().then((DataSnapshot datasnapshot) {
      print(datasnapshot.value);
    });
  }*/
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
