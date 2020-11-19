class PersonList {
  int id;
  String personName;
  String personMobile;
  String personEmail;
  int serviceId;
  String serviceName;
  int isActive;

  PersonList(
      {this.id,
      this.personName,
      this.personMobile,
      this.personEmail,
      this.serviceId,
      this.serviceName,
      this.isActive});

  PersonList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personName = json['person_name'];
    personMobile = json['person_mobile'];
    personEmail = json['person_email'];
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['person_name'] = this.personName;
    data['person_mobile'] = this.personMobile;
    data['person_email'] = this.personEmail;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['is_active'] = this.isActive;
    return data;
  }
}
