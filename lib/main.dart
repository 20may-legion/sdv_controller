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

  SharedPreferences pr = await SharedPreferences.getInstance();
  bool logedin = pr.containsKey('cuid') ? true : false;

  print(logedin);

  runApp(MyApp(logedin: logedin));
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  MyApp({this.logedin});
  bool logedin;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _cuid;

  void getuid() async {
    SharedPreferences pr = await SharedPreferences.getInstance();
    setState(() {
      _cuid = pr.getString('cuid');
    });
    print("sp uid $_cuid");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuid();
  }

  @override
  Widget build(BuildContext context) {
    bool login = widget.logedin;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ignore: unrelated_type_equality_checks\

      home: widget.logedin
          ? FbDb(
              cuid: _cuid,
            )
          : Welcome(),
    );
  }
}
