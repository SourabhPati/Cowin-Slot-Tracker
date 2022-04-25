import 'package:flutter/material.dart';
import 'package:cowin_slot_tracker/getSlotsInfo.dart';

class JsonTester extends StatefulWidget {
  @override
  _JsonTesterState createState() => _JsonTesterState();
}

class _JsonTesterState extends State<JsonTester> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFded5ef),
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, bottom: 30, left: 30, right: 30),
          child: SizedBox(
            child: Container(
              child: getListView(),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFe9e3f4), Color(0xFFded5ef)]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6e47b8),
                    blurRadius: 50.0,
                    spreadRadius: 20.0,
                  ), //BoxShadow
                  BoxShadow(
                    color: Color(0xFF6e47b8),
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 1.0,
                  ), //BoxShadow
                ],
              ), //BoxDecoration
            ), //Container
          ), //SizedBox
        ), //Padding
      ),
    ); //Center
  }
}
