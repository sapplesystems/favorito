class appointmentModel {
  String status;
  String message;
  Data data;

  appointmentModel({this.status, this.message, this.data});

  appointmentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String name;
  String contact;
  int serviceId;
  int personId;
  String specialNotes;
  String createdDate;
  String createdTime;

  Data(
      {this.id,
      this.name,
      this.contact,
      this.serviceId,
      this.personId,
      this.specialNotes,
      this.createdDate,
      this.createdTime});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contact = json['contact'];
    serviceId = json['service_id'];
    personId = json['person_id'];
    specialNotes = json['special_notes'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['service_id'] = this.serviceId;
    data['person_id'] = this.personId;
    data['special_notes'] = this.specialNotes;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    return data;
  }
}

