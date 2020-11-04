class SlotData {
  int id;
  String name;
  String contact;
  int noOfPerson;
  String specialNotes;
  String createdDate;
  String createdTime;
  String startTime;
  String endTime;

  SlotData(
      {this.id,
      this.name,
      this.contact,
      this.noOfPerson,
      this.specialNotes,
      this.createdDate,
      this.createdTime,
      this.startTime,
      this.endTime});

  SlotData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contact = json['contact'];
    noOfPerson = json['no_of_person'];
    specialNotes = json['special_notes'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['no_of_person'] = this.noOfPerson;
    data['special_notes'] = this.specialNotes;
    data['created_date'] = this.createdDate;
    data['created_time'] = this.createdTime;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}
