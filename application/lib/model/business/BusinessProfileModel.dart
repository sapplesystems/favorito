class BusinessProfileModel {
  String status;
  String message;
  Data data;
  List<String> hoursDropDownList;

  BusinessProfileModel(
      {this.status, this.message, this.data, this.hoursDropDownList});

  BusinessProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    hoursDropDownList = json['hours_drop_down_list']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['hours_drop_down_list'] = this.hoursDropDownList;
    return data;
  }
}

class Data {
  int id;
  String businessId;
  String businessName;
  String postalCode;
  String businessPhone;
  String landline;
  int reachWhatsapp;
  String businessEmail;
  String photo;
  String address1;
  String address2;
  String address3;
  String pincode;
  String townCity;
  int stateId;
  int countryId;
  String location;
  int byAppointmentOnly;
  String workingHours;
  // List<String> website;
  String shortDescription;
  String businessStatus;
  List<Hours> hours;

  Data(
      {this.id,
      this.businessId,
      this.businessName,
      this.postalCode,
      this.businessPhone,
      this.landline,
      this.reachWhatsapp,
      this.businessEmail,
      this.photo,
      this.address1,
      this.address2,
      this.address3,
      this.pincode,
      this.townCity,
      this.stateId,
      this.countryId,
      this.location,
      this.byAppointmentOnly,
      this.workingHours,
      // this.website,
      this.shortDescription,
      this.businessStatus,
      this.hours});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    businessName = json['business_name'];
    postalCode = json['postal_code'];
    businessPhone = json['business_phone'];
    landline = json['landline'];
    reachWhatsapp = json['reach_whatsapp'];
    businessEmail = json['business_email'];
    photo = json['photo'];
    address1 = json['address1'];
    address2 = json['address2'];
    address3 = json['address3'];
    pincode = json['pincode'];
    townCity = json['town_city'];
    stateId = json['state_id'];
    countryId = json['country_id'];
    location = json['location'];
    byAppointmentOnly = json['by_appointment_only'];
    workingHours = json['working_hours'];
    // website = json['website']?.cast<String>();
    shortDescription = json['short_description'];
    businessStatus = json['business_status'];
    if (json['hours'] != null) {
      hours = new List<Hours>();
      json['hours'].forEach((v) {
        hours.add(new Hours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['business_name'] = this.businessName;
    data['postal_code'] = this.postalCode;
    data['business_phone'] = this.businessPhone;
    data['landline'] = this.landline;
    data['reach_whatsapp'] = this.reachWhatsapp;
    data['business_email'] = this.businessEmail;
    data['photo'] = this.photo;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['address3'] = this.address3;
    data['pincode'] = this.pincode;
    data['town_city'] = this.townCity;
    data['state_id'] = this.stateId;
    data['country_id'] = this.countryId;
    data['location'] = this.location;
    data['by_appointment_only'] = this.byAppointmentOnly;
    data['working_hours'] = this.workingHours;
    // data['website'] = this.website;
    data['short_description'] = this.shortDescription;
    data['business_status'] = this.businessStatus;
    if (this.hours != null) {
      data['hours'] = this.hours.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Hours {
  int id;
  String day;
  String startHours;
  String endHours;
  bool open;
  bool selected;

  Hours(
      {this.id,
      this.day,
      this.startHours,
      this.endHours,
      this.open,
      this.selected});

  Hours.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    startHours = json['start_hours'];
    endHours = json['end_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this.day;
    data['start_hours'] = this.startHours;
    data['end_hours'] = this.endHours;
    return data;
  }

  String toString() =>
      "{day:$day,startHours:$startHours,endHours:$endHours,open:$open,selected:$selected}";
}
