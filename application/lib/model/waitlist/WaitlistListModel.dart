class WaitlistListModel {
  String status;
  String message;
  List<WaitlistModel> data;

  WaitlistListModel({this.status, this.message, this.data});

  WaitlistListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<WaitlistModel>();
      json['data'].forEach((v) {
        data.add(new WaitlistModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WaitlistModel {
  int id;
  String name;
  String contact;
  int noOfPerson;
  String specialNotes;
  String waitlistDate;
  String walkinAt;

  WaitlistModel(
      {this.id,
      this.name,
      this.contact,
      this.noOfPerson,
      this.specialNotes,
      this.waitlistDate,
      this.walkinAt});

  WaitlistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contact = json['contact'];
    noOfPerson = json['no_of_person'];
    specialNotes = json['special_notes'];
    waitlistDate = json['waitlist_date'];
    walkinAt = json['walkin_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['no_of_person'] = this.noOfPerson;
    data['special_notes'] = this.specialNotes;
    data['waitlist_date'] = this.waitlistDate;
    data['walkin_at'] = this.walkinAt;
    return data;
  }
}
