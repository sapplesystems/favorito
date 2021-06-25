class SlotData {
  int id;
  String name;
  String contact;
  int noOfPerson;
  String person_name;
  String service_name;
  String specialNotes;
  String occasion;
  String createdDate;
  String createdTime;

  SlotData(
      {this.id,
      this.name,
      this.contact,
      this.person_name,
      this.service_name,
      this.occasion,
      this.noOfPerson,
      this.specialNotes,
      this.createdDate,
      this.createdTime});

  SlotData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contact = json['contact'];
    person_name = json['person_name'];
    service_name = json['service_name'];
    occasion = json['occasion'];
    noOfPerson = json['no_of_person'];
    specialNotes = json['special_notes'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['person_name'] = this.contact;
    data['no_of_person'] = this.noOfPerson;
    data['occasion'] = this.occasion;
    data['service_name'] = this.service_name;
    data['special_notes'] = this.specialNotes;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    return data;
  }
}
