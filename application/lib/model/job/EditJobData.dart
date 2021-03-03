class EditJobData {
  int id;
  String title;
  String description;
  String skills;
  String contactVia;
  String contactValue;
  String pincode;

  EditJobData(
      {this.id,
      this.title,
      this.description,
      this.skills,
      this.contactVia,
      this.contactValue,
      this.pincode});

  EditJobData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    skills = json['skills'];
    contactVia = json['contact_via'];
    contactValue = json['contact_value'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['skills'] = this.skills;
    data['contact_via'] = this.contactVia;
    data['contact_value'] = this.contactValue;
    data['pincode'] = this.pincode;
    return data;
  }
}
