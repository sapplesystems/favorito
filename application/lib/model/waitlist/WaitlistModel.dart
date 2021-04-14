class WaitlistModel {
  int id;
  String name;
  String contact;
  int noOfPerson;
  String specialNotes;
  String waitlistStatus;
  String waitlistDate;
  String walkinAt;
  String bookedBy;

  WaitlistModel(
      {this.id,
      this.name,
      this.contact,
      this.noOfPerson,
      this.specialNotes,
      this.waitlistStatus,
      this.waitlistDate,
      this.walkinAt,
      this.bookedBy});

  WaitlistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contact = json['contact'];
    noOfPerson = json['no_of_person'];
    specialNotes = json['special_notes'];
    waitlistStatus = json['waitlist_status'];
    waitlistDate = json['waitlist_date'];
    walkinAt = json['walkin_at'];
    bookedBy = json['booked_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['no_of_person'] = this.noOfPerson;
    data['special_notes'] = this.specialNotes;
    data['waitlist_status'] = this.waitlistStatus;
    data['waitlist_date'] = this.waitlistDate;
    data['walkin_at'] = this.walkinAt;
    data['booked_by'] = this.bookedBy;
    return data;
  }
}
