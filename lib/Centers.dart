import 'package:cowin_slot_tracker/UserConfiguration.dart';

UserConfiguration uc = new UserConfiguration();

class VaccinationCenter {
  String name;
  String address;
  String state;
  String district;
  String blockName;
  int pincode;
  String feeType;
  List<VaccinationSession> sessions;

  VaccinationCenter(
      {this.name,
      this.address,
      this.state,
      this.district,
      this.blockName,
      this.pincode,
      this.feeType,
      this.sessions});

  factory VaccinationCenter.fromJson(dynamic json) {
    var sessionObjects = json['sessions'] as List;
    List<VaccinationSession> sessionList =
        sessionObjects.map((i) => VaccinationSession.fromJson(i)).toList();

    return VaccinationCenter(
        name: json['name'] as String,
        address: json['address'] as String,
        state: json['state_name'] as String,
        district: json['district_name'] as String,
        blockName: json['block_name'] as String,
        pincode: json['pincode'] as int,
        feeType: json['fee_type'] as String,
        sessions: sessionList);
  }

  bool hasPreferredSession() {
    for (VaccinationSession v in sessions) {
      if (v.isPreferredSession()) return true;
    }
    return false;
  }

  get getName => this.name;

  set setName(name) => this.name = name;

  get getAddress => this.address;

  set setAddress(address) => this.address = address;

  get getState => this.state;

  set setState(state) => this.state = state;

  get getDistrict => this.district;

  set setDistrict(district) => this.district = district;

  get getBlockName => this.blockName;

  set setBlockName(blockName) => this.blockName = blockName;

  get getPincode => this.pincode;

  set setPincode(pincode) => this.pincode = pincode;

  get getFeeType => this.feeType;

  set setFeeType(feeType) => this.feeType = feeType;

  get getSessions => this.sessions;

  set setSessions(sessions) => this.sessions = sessions;

  @override
  String toString() {
    return '{ ${this.name}, ${this.address},${this.state},${this.district},${this.blockName},${this.pincode},${this.feeType}, Sessions :\n ${this.sessions.toString()}}';
  }
}

class VaccinationSession {
  String date;
  int availaibleCapacity;
  int minAge;
  String vaccine;
  int dose1Cap;
  int dose2Cap;

  VaccinationSession(
      {this.date,
      this.availaibleCapacity,
      this.minAge,
      this.vaccine,
      this.dose1Cap,
      this.dose2Cap});

  factory VaccinationSession.fromJson(dynamic json) {
    return VaccinationSession(
        date: json['date'] as String,
        availaibleCapacity: json['available_capacity'] as int,
        minAge: json['min_age_limit'] as int,
        vaccine: json['vaccine'] as String,
        dose1Cap: json['available_capacity_dose1'] as int,
        dose2Cap: json['available_capacity_dose2'] as int);
  }

  bool isSlotAvailable() {
    if (availaibleCapacity > 0)
      return true;
    else
      return false;
  }

  bool hasPreferredVaccine() {
    if (uc.preferredVaccine == 'ANY') return true;
    if (vaccine == uc.preferredVaccine)
      return true;
    else
      return false;
  }

  bool hasPreferredAge() {
    if (uc.restrictAge18 == false) return true;
    if (minAge == 18)
      return true;
    else
      return false;
  }

  bool hasPreferredDose() {
    if (uc.preferredDose == 'ANY') return true;
    if (uc.preferredDose == 'Dose-1')
      return dose1Cap > 0;
    else
      return dose2Cap > 0;
  }

  bool isPreferredSession() {
    return isSlotAvailable() &&
        hasPreferredVaccine() &&
        hasPreferredAge() &&
        hasPreferredDose();
  }

  @override
  String toString() {
    return '{ ${this.date}, ${this.availaibleCapacity},${this.minAge},${this.vaccine},${this.dose1Cap},${this.dose2Cap}}';
  }
}
