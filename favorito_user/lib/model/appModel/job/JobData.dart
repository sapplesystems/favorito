class JobData {
  int id;
  String businessId;
  String title;
  String description;
  int noOfPosition;
  String skills;
  String contactVia;
  String contactValue;
  String city;
  String pincode;

  JobData(
      {this.id,
      this.businessId,
      this.title,
      this.description,
      this.noOfPosition,
      this.skills,
      this.contactVia,
      this.contactValue,
      this.city,
      this.pincode});

  JobData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    title = json['title'];
    description = json['description'];
    noOfPosition = json['no_of_position'];
    skills = json['skills'];
    contactVia = json['contact_via'];
    contactValue = json['contact_value'];
    city = json['city'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['no_of_position'] = this.noOfPosition;
    data['skills'] = this.skills;
    data['contact_via'] = this.contactVia;
    data['contact_value'] = this.contactValue;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    return data;
  }
}
