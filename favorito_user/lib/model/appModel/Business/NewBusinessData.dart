class NewBusinessData {
  int id;
  String businessId;
  String businessName;
  String postalCode;
  String landline;
  int reachWhatsapp;
  String businessEmail;
  String address1;
  String address2;
  String address3;
  String pincode;
  String townCity;
  String location;
  String website;
  String shortDescription;
  String photo;
  String businessStatus;

  NewBusinessData(
      {this.id,
      this.businessId,
      this.businessName,
      this.postalCode,
      this.landline,
      this.reachWhatsapp,
      this.businessEmail,
      this.address1,
      this.address2,
      this.address3,
      this.pincode,
      this.townCity,
      this.location,
      this.website,
      this.shortDescription,
      this.photo,
      this.businessStatus});

  NewBusinessData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    businessName = json['business_name'];
    postalCode = json['postal_code'];
    landline = json['landline'];
    reachWhatsapp = json['reach_whatsapp'];
    businessEmail = json['business_email'];
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    pincode = json['pincode'];
    townCity = json['town_city'];
    location = json['location'];
    website = json['website'];
    shortDescription = json['short_description'];
    photo = json['photo'];
    businessStatus = json['business_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['business_name'] = this.businessName;
    data['postal_code'] = this.postalCode;
    data['landline'] = this.landline;
    data['reach_whatsapp'] = this.reachWhatsapp;
    data['business_email'] = this.businessEmail;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['address3'] = this.address3;
    data['pincode'] = this.pincode;
    data['town_city'] = this.townCity;
    data['location'] = this.location;
    data['website'] = this.website;
    data['short_description'] = this.shortDescription;
    data['photo'] = this.photo;
    data['business_status'] = this.businessStatus;
    return data;
  }
}
