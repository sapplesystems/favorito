import 'package:Favorito/model/job/CityList.dart';

class CreateJobRequiredDataModel {
  String status;
  String message;
  Data data;

  CreateJobRequiredDataModel({this.status, this.message, this.data});

  CreateJobRequiredDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<String> contactVia;
  List<CityList> cityList;

  Data({this.contactVia, this.cityList});

  Data.fromJson(Map<String, dynamic> json) {
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

  getCityIdByName(String _name) {
    int id;
    cityList.forEach((element) {
      if (element.city == _name) {
        id = element.id;
      }
    });
    return id;
  }
}

// class CityList {
//   int id;
//   String city;

//   CityList({this.id, this.city});

//   CityList.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     city = json['city'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['city'] = this.city;
//     return data;
//   }

//   bool isEqual(CityList model) {
//     return this?.id == model?.id;
//   }

//   String userAsString() {
//     return '${this.city}';
//   }
// }
