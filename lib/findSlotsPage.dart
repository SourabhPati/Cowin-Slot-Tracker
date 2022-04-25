import 'package:cowin_slot_tracker/AvailableSlotsPage.dart';
import 'package:cowin_slot_tracker/getSlotsInfo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import 'package:cowin_slot_tracker/UserConfiguration.dart';

UserConfiguration uc = new UserConfiguration();

class FindSlots extends StatefulWidget {
  @override
  _FindSlotsState createState() => _FindSlotsState();
}

class _FindSlotsState extends State<FindSlots> {
  List<String> apiQueries;
  bool searchingSlots;
  int endTime;

  @override
  void initState() {
    super.initState();
    initializeProperties();
    formQueries();
    onTimerEnd();
  }

  void initializeProperties() {
    apiQueries = [];
    searchingSlots = true;
  }

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
              child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                  children: <Widget>[
                    searchingSlots
                        ? Center(
                            child: Text("Looking for available slots . . .",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20)))
                        : Center(
                            child: Text(
                            "No available slots found :(",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 22),
                          )),
                    SizedBox(height: 150),
                    searchingSlots
                        ? Center(
                            child: SizedBox(
                                height: 70.0,
                                width: 70.0,
                                child: CircularProgressIndicator(
                                    strokeWidth: 5.0)),
                          )
                        : Center(
                            child: Column(
                              children: [
                                Text("Next Search in :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22)),
                                SizedBox(
                                  height: 40,
                                ),
                                CountdownTimer(
                                  endTime: endTime,
                                  onEnd: onTimerEnd,
                                  widgetBuilder: (_, time) {
                                    var f = NumberFormat('00');
                                    searchingSlots =
                                        true; // Could cause problems
                                    if (time != null) {
                                      if (time.min == null) {
                                        return Text(f.format(time.sec),
                                            style: TextStyle(fontSize: 74));
                                      } else {
                                        return Text(
                                            f.format(time.min) +
                                                ':' +
                                                f.format(time.sec),
                                            style: TextStyle(fontSize: 74));
                                      }
                                    } else {
                                      print("!!!!!!!! NULL TIME  !!!!!");
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                  ]),
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

  void onTimerEnd() async {
    bool gotSlots = false;
    gotSlots = await getSlotsInfo(apiQueries);
    if (gotSlots) {
      if (uc.centersWithVaccines.length > 0) {
        notify();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AvailableSlots()),
        );
      } else {
        setState(() {
          endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 122;
          searchingSlots = !searchingSlots;
        });
      }
    }
  }

  void formQueries() {
    DateTime now = DateTime.now();
    String date = DateFormat('dd-MM-yyyy').format(now);
    String api =
        'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarBy';
    for (int districtCode in uc.districtCodes) {
      String apiEndpoint = api +
          'District?district_id=' +
          districtCode.toString() +
          '&date=' +
          date;
      apiQueries.add(apiEndpoint);
    }
    for (String pincode in uc.pincodes) {
      String apiEndpoint =
          api + 'Pin?pincode=' + pincode.toString() + '&date=' + date;
      apiQueries.add(apiEndpoint);
    }
  }
}
