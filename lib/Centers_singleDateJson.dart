class VaccinationCenter {
  String center;
  String date;
  int availaibleCapacity;
  int minAge;
  String vaccine;

  VaccinationCenter(
      {this.center,
      this.date,
      this.availaibleCapacity,
      this.minAge,
      this.vaccine});

  factory VaccinationCenter.fromJson(dynamic json) {
    return VaccinationCenter(
        center: json['address'] as String,
        date: json['date'] as String,
        availaibleCapacity: json['available_capacity'] as int,
        minAge: json['min_age_limit'] as int,
        vaccine: json['vaccine'] as String);
  }

  bool hasVaccine() {
    if (availaibleCapacity > 0)
      return true;
    else
      return false;
  }

  @override
  String toString() {
    return '{ ${this.center}, ${this.date}, ${this.availaibleCapacity},${this.minAge},${this.vaccine}}';
  }
}
