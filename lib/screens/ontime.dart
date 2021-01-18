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
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

FirebaseAuth auth = FirebaseAuth.instance;
DatabaseReference dbref = FirebaseDatabase.instance.reference();
int fantime=0,lightime=0;
int fminute,fhour,lminute,lhour;
String cuid;
class OnTime extends StatefulWidget {
  String cuid;
  OnTime({Key key, @required this.cuid}) : super(key: key);
  @override
  _OnTimeState createState() => _OnTimeState();
}

class _OnTimeState extends State<OnTime> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      cuid= widget.cuid;
    });
    dbref
        .child('Staffroom')
        .child(custaffroom)
        .child(cucabin)
        .child('fan')
        .child('ontime')
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        fantime = snapshot.value;
        fminute=fantime~/60;
        //print(snapshot.value);
        //print(FanSwitch);
      });
    });

    dbref
        .child('Staffroom')
        .child(custaffroom)
        .child(cucabin)
        .child('light')
        .child('ontime')
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        lightime = snapshot.value;
        lminute=lightime~/60;
        //print(snapshot.value);
        //print(FanSwitch);
      });

    });
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: <Widget>[
              SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      color: Colors.blueGrey.shade100,

                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Image(image: AssetImage('images/fan.png'),height: 150,),
                            SizedBox(height: 16),
                            Container(
                              color: Colors.blueGrey.shade200,
                              constraints: BoxConstraints.expand(
                                height: 30,width: 160
                              ),
                              child: Center(child: Text("ontime : $fminute minutes")),
                            )
                          ],
                        ),
                      ),

                    ),Container(
                      color: Colors.blueGrey.shade100,

                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Image(image: AssetImage('images/lamp.png'),height: 150,),
                            SizedBox(height: 16),
                            Container(
                              color: Colors.blueGrey.shade200,
                              constraints: BoxConstraints.expand(
                                height: 30,width: 160
                              ),
                              child: Center(child: Text("ontime : $lminute minutes")),
                            )
                          ],
                        ),
                      ),

                    ),


                  ]
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Container(
                  color: Colors.grey.shade200,

                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(text: 'usage'),
                    legend: Legend(isVisible: false),
                    series: <LineSeries<Usage,String>>[
                      LineSeries(dataSource: [
                        Usage("1", 25),
                        Usage("2", 20),
                        Usage("3", 22),
                        Usage("4", 28),
                        Usage("5", 19),

                      ], xValueMapper: (Usage usage,_)=> usage.date,
                          yValueMapper: (Usage usage,_)=> usage.unit,
                          dataLabelSettings: DataLabelSettings(isVisible: true),),
                      ],
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Usage {
  Usage(this.date,this.unit);
  String date;
  double unit;
}
