class Detail {
  String fullName;
  String email;
  String phone;
  String postal;
  String profileId;
  int reachWhatsapp;
  String shortDescription;

  Detail(
      {this.fullName,
      this.email,
      this.phone,
      this.postal,
      this.profileId,
      this.reachWhatsapp,
      this.shortDescription});

  Detail.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    email = json['email'];
    phone = json['phone'];
    postal = json['postal'];
    profileId = json['profile_id'];
    reachWhatsapp = json['reach_whatsapp'];
    shortDescription = json['short_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['postal'] = this.postal;
    data['profile_id'] = this.profileId;
    data['reach_whatsapp'] = this.reachWhatsapp;
    data['short_description'] = this.shortDescription;
    return data;
  }
}
