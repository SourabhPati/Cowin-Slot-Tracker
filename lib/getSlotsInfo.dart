import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cowin_slot_tracker/Centers.dart';
import 'package:http/http.dart' as http;

import 'package:cowin_slot_tracker/UserConfiguration.dart';

UserConfiguration uc = new UserConfiguration();

Future<List<VaccinationCenter>> fetchVaccantionCenters(String url) async {
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the call to the server was successful (returns OK), parse the JSON.
    var centerObjects = jsonDecode(response.body)['centers'] as List;
    if (centerObjects != null) {
      List<VaccinationCenter> centers = centerObjects
          .map((centerJson) => VaccinationCenter.fromJson(centerJson))
          .toList();
      //print(centers);
      print(centers.length);
      return centers;
    } else {
      print("NULL JSON");
      return [];
    }
  } else {
    // If that call was not successful (response was unexpected), it throw an error.
    throw Exception('Failed to retrieve data from api');
  }
}

Future<bool> getSlotsInfo(List<String> apiEndpoints) async {
  VaccinationCenter vCenterWithVaccine = new VaccinationCenter();
  vCenterWithVaccine.sessions = [];
  for (String query in apiEndpoints) {
    List<VaccinationCenter> allVCenters = await fetchVaccantionCenters(query);
    for (VaccinationCenter vCenter in allVCenters) {
      if (!vCenter.hasPreferredSession()) continue;
      vCenterWithVaccine.name = vCenter.name;
      vCenterWithVaccine.address = vCenter.address;
      vCenterWithVaccine.state = vCenter.state;
      vCenterWithVaccine.district = vCenter.district;
      vCenterWithVaccine.blockName = vCenter.blockName;
      vCenterWithVaccine.pincode = vCenter.pincode;
      vCenterWithVaccine.feeType = vCenter.feeType;
      for (VaccinationSession vSession in vCenter.sessions) {
        if (vSession.isPreferredSession())
          vCenterWithVaccine.sessions.add(vSession);
      }
      uc.centersWithVaccines.add(vCenterWithVaccine);
      vCenterWithVaccine = new VaccinationCenter();
      vCenterWithVaccine.sessions = [];
    }
  }
  return true;
}

Widget getListView() {
  return FutureBuilder<List<VaccinationCenter>>(
      future: fetchVaccantionCenters(
          "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id=453&date=22-5-2021"),
      builder: (context, vaccinationCenters) {
        if (vaccinationCenters.hasData) {
          return ListView.builder(
              itemCount: vaccinationCenters.data.length,
              itemBuilder: (_, index) {
                return Wrap(
                  direction: Axis.horizontal,
                  children: [
                    Text(vaccinationCenters.data[index].toString() + "\n"),
                  ],
                );
              });
        } else if (vaccinationCenters.hasError) {
          return Text("${vaccinationCenters.error}");
        }
        return CircularProgressIndicator();
      });
}
