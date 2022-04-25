import 'package:cowin_slot_tracker/Centers.dart';

class UserConfiguration {
  bool restrictAge18;
  List<int> districtCodes;
  List<String> pincodes;
  String preferredVaccine;
  String preferredDose;
  List<VaccinationCenter> centersWithVaccines;

  static final UserConfiguration _userConf = UserConfiguration._internal();

  factory UserConfiguration() => _userConf;

  UserConfiguration._internal() {
    this.restrictAge18 = false;
    this.preferredVaccine = 'ANY';
    this.preferredDose = 'ANY';
    districtCodes = [];
    pincodes = [];
    centersWithVaccines = [];
  }

  bool get getRestrictAge18 => this.restrictAge18;

  set setRestrictAge18(bool restrictAge18) =>
      this.restrictAge18 = restrictAge18;

  get getDistrictCodes => this.districtCodes;

  set setDistrictCodes(districtCodes) => this.districtCodes = districtCodes;

  get getPincodes => this.pincodes;

  set setPincodes(pincodes) => this.pincodes = pincodes;

  get getPreferredVaccine => this.preferredVaccine;

  set setPreferredVaccine(preferredVaccine) =>
      this.preferredVaccine = preferredVaccine;

  void reset() {
    this.restrictAge18 = false;
    this.preferredVaccine = 'ANY';
    this.preferredDose = 'ANY';
    districtCodes = [];
    pincodes = [];
    centersWithVaccines = [];
  }

  @override
  String toString() {
    return '''
      18+ only: ${this.restrictAge18.toString()} 
      District Codes: ${this.districtCodes.toString()}
      Pincodes: ${this.pincodes.toString()}
      Preferred Vaccine: ${this.preferredVaccine.toString()}''';
  }
}
