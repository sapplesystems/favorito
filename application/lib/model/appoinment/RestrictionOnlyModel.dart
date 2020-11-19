class RestrictionOnlyModel {
  int id;
  int personId;
  String personName;
  int serviceId;
  String serviceName;
  String dateTime;

  RestrictionOnlyModel(
      {this.id,
      this.personId,
      this.personName,
      this.serviceId,
      this.serviceName,
      this.dateTime});

  RestrictionOnlyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personId = json['person_id'];
    personName = json['person_name'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['person_id'] = this.personId;
    data['person_name'] = this.personName;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['date_time'] = this.dateTime;
    return data;
  }
}
