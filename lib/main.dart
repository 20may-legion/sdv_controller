import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sdv_controller/screens/signup.dart';
import 'dart:async';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import './screens/signup.dart';
import './screens/signin.dart';
import './screens/fbdb.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new NeumorphicApp(
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFF2F2F2),
        accentColor: Colors.blueGrey.shade100,
        lightSource: LightSource.topLeft,
        depth: 5,
        intensity: 1,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Color(0xFF292D32),
        accentColor: Colors.cyan.shade500,
        lightSource: LightSource.topLeft,
        depth: 3,
        intensity: 0.75,
      ),
      title: 'Navigation',
      routes: <String, WidgetBuilder>{
        //All available pages
        '/Signup': (BuildContext context) => new Signup(),
        '/Signin': (BuildContext context) => new Signin(),
        '/FbDb': (BuildContext context) => new FbDb(),
      },
      home: Welcome(),
      //first page displayed
    );
  }
}

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: AppBar(
        backgroundColor: iconsColor(context),
        title: Text(
          'Welcome to SDV Controller',
          style: TextStyle(
            color: textColor(context),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: NeumorphicText(
                'WE PROVIDE THE BEST SOLUTION OF YOUR NEED!',
                style: NeumorphicStyle(
                    intensity: 1,
                    depth: 3, //customize depth here
                    color: textColor(context) //customize color here
                    ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 30, //customize size here
                  // AND others usual text style properties (fontFamily, fontWeight, ...)
                ),
              ),
            ),
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NeumorphicButton(
                  style: NeumorphicStyle(
                      depth: NeumorphicTheme.of(context).current.depth,
                      intensity: NeumorphicTheme.of(context).current.intensity,
                      color: iconsColor(context)),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/Signin');
                    print(NeumorphicTheme.of(context).current.depth);
                  },
                  child: Text(
                    'already a member!',
                    style: TextStyle(fontSize: 20, color: textColor(context)),
                  ),
                ),
                SizedBox(height: 20),
                NeumorphicButton(
                  style: NeumorphicStyle(
                      depth: NeumorphicTheme.of(context).current.depth,
                      intensity: NeumorphicTheme.of(context).current.intensity,
                      color: iconsColor(context)),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/Signup');
                  },
                  child: Text(
                    'new member!',
                    style: TextStyle(fontSize: 20, color: textColor(context)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

//todo add border
  /*Border iconBorder(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return NeumorphicTheme.of(context).current.border;
    }
  }*/
}
