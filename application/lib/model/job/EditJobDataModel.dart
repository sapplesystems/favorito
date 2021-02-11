class EditJobDataModel {
  String status;
  String message;
  Verbose verbose;
  List<Data> data;

  EditJobDataModel({this.status, this.message, this.verbose, this.data});

  EditJobDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    verbose =
        json['verbose'] != null ? new Verbose.fromJson(json['verbose']) : null;
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.verbose != null) {
      data['verbose'] = this.verbose.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Verbose {
  List<String> contactVia;
  List<CityList> cityList;

  Verbose({this.contactVia, this.cityList});

  Verbose.fromJson(Map<String, dynamic> json) {
    contactVia = json['contact_via']?.cast<String>();
    if (json['city_list'] != null) {
      cityList = new List<CityList>();
      json['city_list'].forEach((v) {
        cityList.add(new CityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact_via'] = this.contactVia;
    if (this.cityList != null) {
      data['city_list'] = this.cityList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityList {
  int id;
  String city;

  CityList({this.id, this.city});

  CityList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city'] = this.city;
    return data;
  }
}

class Data {
  int id;
  String title;
  String description;
  String skills;
  String contactVia;
  int city;
  String pincode;

  Data(
      {this.id,
      this.title,
      this.description,
      this.skills,
      this.contactVia,
      this.city,
      this.pincode});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    skills = json['skills'];
    contactVia = json['contact_via'];
    city = json['city'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['skills'] = this.skills;
    data['contact_via'] = this.contactVia;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    return data;
  }
}
