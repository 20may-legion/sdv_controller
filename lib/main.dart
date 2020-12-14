import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdv_controller/screens/fbdb.dart';
import 'package:sdv_controller/screens/signin.dart';
import 'package:sdv_controller/screens/signup.dart';
import 'package:sdv_controller/screens/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final pr = await SharedPreferences.getInstance();
  bool logedin = pr.containsKey('cuid') ? true : false;
  print(logedin);

  runApp(MyApp(logedin: logedin));
}

class MyApp extends StatefulWidget {
  MyApp({this.logedin});
  final bool logedin;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ignore: unrelated_type_equality_checks
      home: widget.logedin ? FbDb() : Welcome(),
    );
  }
}
