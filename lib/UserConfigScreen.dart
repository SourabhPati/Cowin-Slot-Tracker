import 'package:cowin_slot_tracker/findSlotsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cowin_slot_tracker/maps.dart';

import 'package:cowin_slot_tracker/UserConfiguration.dart';

UserConfiguration uc = new UserConfiguration();

class UserConfigScreen extends StatefulWidget {
  UserConfigScreen({Key key}) : super(key: key);

  @override
  _UserConfigScreenState createState() => _UserConfigScreenState();
}

class _UserConfigScreenState extends State<UserConfigScreen> {
  String _selectedState;
  List<int> _selectedDistrictCodes;
  List<DropdownMenuItem<String>> stateItems;
  List<MultiSelectItem<int>> districtItems;
  List<bool> selectedVaccine;
  List<bool> selectedDose;
  bool enablePinCodeField;
  final pincodesTextController = TextEditingController();
  String pincodesEditingValue;

  void initState() {
    initializeProperties();
    super.initState();
    getStateDropdownItems();
    pincodesTextController.addListener(validatePincodes);
  }

  void initializeProperties() {
    _selectedDistrictCodes = [];
    stateItems = [];
    districtItems = [];
    selectedVaccine = [false, true, false];
    selectedDose = [false, true, false];
    enablePinCodeField = false;
    pincodesEditingValue = "";
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    pincodesTextController.dispose();
    super.dispose();
  }

  void getStateDropdownItems() {
    for (String s in states) {
      stateItems.add(
        new DropdownMenuItem(
          child: Text(s),
          value: s,
        ),
      );
    }
  }

  void getDistrictDropdownItems() {
    districtItems.clear();
    _selectedDistrictCodes.clear();
    for (String s in districtsInState[_selectedState]) {
      districtItems.add(new MultiSelectItem(districtCodes[s], s));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Color(0xFFded5ef),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 40, bottom: 30, left: 30, right: 30),
              child: SizedBox(
                child: Container(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 30),
                    children: <Widget>[
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 79),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Text("Select State"),
                              value: _selectedState,
                              items: stateItems,
                              onChanged: (String val) {
                                setState(() {
                                  _selectedState = val;
                                  // districtItems.clear();
                                  // _selectedDistrictCodes.clear();
                                  getDistrictDropdownItems();
                                });
                              },
                            ),
                          ),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 2.0,
                                  style: BorderStyle.solid,
                                  color: Color(0xFF6641aa)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      districtItems.isEmpty
                          ? Container()
                          : Container(
                              alignment: Alignment.center,
                              child: MultiSelectDialogField(
                                backgroundColor: Color(0xFFded5ef),
                                searchable: true,
                                buttonText: Text(
                                    "                     Selected District(s)"),
                                items: districtItems,
                                listType: MultiSelectListType.CHIP,
                                onConfirm: (values) {
                                  setState(() {
                                    _selectedDistrictCodes = values;
                                    uc.districtCodes = values;
                                  });
                                },
                              ),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 2.0,
                                      style: BorderStyle.solid,
                                      color: Color(0xFF6641aa)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                            ),
                      districtItems.isEmpty
                          ? Container()
                          : SizedBox(
                              height: 15,
                            ),
                      // Text(selectedVaccine.toString()),
                      Container(
                        child: ToggleButtons(
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          renderBorder: false,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text("COVISHIELD")),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text("ANY")),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text("COVAXIN")),
                          ],
                          onPressed: (int index) {
                            setState(() {
                              for (int buttonIndex = 0;
                                  buttonIndex < selectedVaccine.length;
                                  buttonIndex++) {
                                if (buttonIndex == index) {
                                  selectedVaccine[buttonIndex] = true;
                                } else {
                                  selectedVaccine[buttonIndex] = false;
                                }
                              }
                              uc.preferredVaccine = vaccineIndices[index];
                            });
                          },
                          isSelected: selectedVaccine,
                        ),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 2.0,
                                style: BorderStyle.solid,
                                color: Color(0xFF6641aa)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: ToggleButtons(
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          renderBorder: false,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 28),
                                child: Text("Dose-1")),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 21),
                                child: Text("ANY")),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 22),
                                child: Text("Dose-2")),
                          ],
                          onPressed: (int index) {
                            setState(() {
                              for (int buttonIndex = 0;
                                  buttonIndex < selectedDose.length;
                                  buttonIndex++) {
                                if (buttonIndex == index) {
                                  selectedDose[buttonIndex] = true;
                                } else {
                                  selectedDose[buttonIndex] = false;
                                }
                              }
                              uc.preferredDose = vaccineDoseIndices[index];
                            });
                          },
                          isSelected: selectedDose,
                        ),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 2.0,
                                style: BorderStyle.solid,
                                color: Color(0xFF6641aa)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 22),
                              width: 130,
                              height: 30,
                              child: Text("Age Group",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                            SizedBox(
                              width: 130,
                              height: 40,
                              child: LiteRollingSwitch(
                                value: false,
                                textOn: '18+ only',
                                textOff: '18+ & 45+',
                                colorOn: Color(0xFF6e47b8),
                                colorOff: Color(0xFF6e47b8),
                                iconOn: Icons.coronavirus_outlined,
                                iconOff: Icons.coronavirus_rounded,
                                animationDuration: Duration(milliseconds: 800),
                                onChanged: (bool state) {
                                  uc.restrictAge18 = state;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          children: [
                            Container(
                              width: 130,
                              height: 30,
                              child: Text("Pincode Search",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                            SizedBox(
                              width: 130,
                              height: 40,
                              child: LiteRollingSwitch(
                                value: false,
                                textOn: 'Enabled',
                                textOff: 'Disabled',
                                colorOn: Color(0xFF6e47b8),
                                colorOff: Color(0xFF9b80ce),
                                iconOn: Icons.check,
                                iconOff: Icons.power_settings_new,
                                animationDuration: Duration(milliseconds: 800),
                                onChanged: (bool state) {
                                  Future.delayed(Duration.zero, () async {
                                    setState(() {
                                      enablePinCodeField = state;
                                      pincodesTextController.text = "";
                                      uc.pincodes = [];
                                    });
                                  });
                                  // enablePinCodeField = state;
                                },
                              ),
                            ),
                          ],
                        ),
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      // Text(enablePinCodeField.toString()),
                      !enablePinCodeField
                          ? Container()
                          : Container(
                              child: TextField(
                                controller: pincodesTextController,
                                keyboardType: TextInputType.number,
                                enabled: enablePinCodeField,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF6641aa))),
                                    labelText: 'Pincodes',
                                    hintText: 'Eg : 751030,121001,600089'),
                              ),
                              // decoration: ShapeDecoration(
                              //   shape: RoundedRectangleBorder(
                              //     side: BorderSide(
                              //         width: 2.0,
                              //         style: BorderStyle.solid,
                              //         color: Color(0xFF6641aa)),
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(5.0)),
                              //   ),
                              // ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isreadyToSubmit()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FindSlots()),
                              );
                            }
                            //print(uc.toString());
                          },
                          child: const Text('Find available slots',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
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
        ),
        onWillPop: () async {
          return false;
        }); //Center
  }

  // bool isDigit(String s, int idx) => (s.codeUnitAt(idx) ^ 0x30) <= 9;
  bool isDigit(String s) {
    return s == '0' ||
        s == '1' ||
        s == '2' ||
        s == '3' ||
        s == '4' ||
        s == '5' ||
        s == '6' ||
        s == '7' ||
        s == '8' ||
        s == '9';
  }

  void validatePincodes() {
    //print(pincodesTextController.text.toString());
    String value = pincodesTextController.text.toString();
    bool isValid = true;
    int pincodeLen = 1;
    for (int i = 0; i < value.length; ++i) {
      if (pincodeLen == 1) {
        if (!isDigit(value[i]) || value[i] == '0') isValid = false;
      } else if (pincodeLen == 7) {
        isValid = value[i] == ',';
        pincodeLen = 0;
      } else {
        isValid = isDigit(value[i]);
      }
      pincodeLen++;
    }
    if (isValid) {
      pincodesEditingValue = value;
    } else {
      pincodesTextController.text = pincodesEditingValue;
      pincodesTextController.selection = TextSelection.fromPosition(
          TextPosition(offset: pincodesTextController.text.length));
    }
  }

  bool isreadyToSubmit() {
    bool res = true;
    if (_selectedDistrictCodes.isEmpty && pincodesEditingValue.isEmpty) {
      Fluttertoast.showToast(
          msg: "Select atleast one district or enter one pincode",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Color(0xFF6641aa),
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    if (enablePinCodeField && pincodesEditingValue.isNotEmpty) {
      List<String> pincodes = pincodesTextController.text.split(',');
      pincodes.remove('');
      if (pincodes.last.length != 6) {
        Fluttertoast.showToast(
            msg: "Invalid Pincode(s)",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Color(0xFF6641aa),
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      }
      uc.pincodes = pincodes;
    }
    return res;
  }
}
