import 'package:cowin_slot_tracker/UserConfigScreen.dart';
import 'package:cowin_slot_tracker/UserConfiguration.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
//import 'package:cowin_slot_tracker/findSlotsPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cowin_slot_tracker/main.dart';

UserConfiguration uc = new UserConfiguration();

class AvailableSlots extends StatefulWidget {
  @override
  _AvailableSlotsState createState() => _AvailableSlotsState();
}

class _AvailableSlotsState extends State<AvailableSlots> {
  var _url = 'https://selfregistration.cowin.gov.in/';
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();

  @override
  void initState() {
    super.initState();
    //notify();
  }

  @override
  Widget build(BuildContext context) {
    print(uc.centersWithVaccines.length);
    return WillPopScope(
      child: Scaffold(
          backgroundColor: Color(0xFFded5ef),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40, bottom: 30, left: 30, right: 30),
              child: Container(
                child: ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    children: <Widget>[
                      SizedBox(
                        height: 650,
                        child: ListView.builder(
                            itemCount: uc.centersWithVaccines.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ExpansionTileCard(
                                  baseColor: Color(0xFFb19cd9),
                                  expandedColor: Color(0xFFCDBEEB),
                                  title: Text(
                                    uc.centersWithVaccines[index].name
                                        .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    uc.centersWithVaccines[index].blockName
                                            .toString() +
                                        "          " +
                                        uc.centersWithVaccines[index].feeType
                                            .toString(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  children: <Widget>[
                                    Divider(
                                      thickness: 10.0,
                                      height: 3.0,
                                      color: Color(0xFF6e47b8),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 2.5,
                                          vertical: 8.0,
                                        ),
                                        child: SizedBox(
                                          height: 210,
                                          child: ListView.builder(
                                              itemCount: uc
                                                  .centersWithVaccines[index]
                                                  .sessions
                                                  .length,
                                              itemBuilder: (_, indx) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(uc
                                                                .centersWithVaccines[
                                                                    index]
                                                                .sessions[indx]
                                                                .date +
                                                            '        '),
                                                        Text(uc
                                                                .centersWithVaccines[
                                                                    index]
                                                                .sessions[indx]
                                                                .vaccine +
                                                            '           '),
                                                        Text('Age: ' +
                                                            uc
                                                                .centersWithVaccines[
                                                                    index]
                                                                .sessions[indx]
                                                                .minAge
                                                                .toString() +
                                                            '+'),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Text('           Dose 1: ' +
                                                            uc
                                                                .centersWithVaccines[
                                                                    index]
                                                                .sessions[indx]
                                                                .dose1Cap
                                                                .toString() +
                                                            '               '),
                                                        Text('Dose 2: ' +
                                                            uc
                                                                .centersWithVaccines[
                                                                    index]
                                                                .sessions[indx]
                                                                .dose2Cap
                                                                .toString()),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8),
                                                      child: Divider(
                                                        thickness: 2.0,
                                                        height: 3.0,
                                                        color:
                                                            Color(0xFF9b80ce),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
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
            ), //Padding
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 7),
            child: FloatingActionButton.extended(
              label: Text(
                "Book Slot Now",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: _launchCowinPage,
            ),
          )),
      onWillPop: () async {
        uc.reset();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserConfigScreen()),
        );
        return false;
      },
    ); //Center
  }

  void _launchCowinPage() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}

void notify() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('What is channel ID', 'What is channel name',
          'Channel description :O ..Okay am leaving',
          playSound: true,
          sound: RawResourceAndroidNotificationSound('@raw/siren'),
          importance: Importance.max,
          priority: Priority.high);

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(1, 'Vaccination Slot Availaible',
      'Tap to book now.', platformChannelSpecifics,
      payload: 'mypayload');
}
