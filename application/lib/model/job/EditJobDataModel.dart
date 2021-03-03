import 'package:Favorito/model/job/CityList.dart';
import 'package:Favorito/model/job/EditJobData.dart';

class EditJobDataModel {
  String status;
  String message;
  Verbose verbose;
  List<EditJobData> data;

  EditJobDataModel({this.status, this.message, this.verbose, this.data});

  EditJobDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    verbose =
        json['verbose'] != null ? new Verbose.fromJson(json['verbose']) : null;
    if (json['data'] != null) {
      data = new List<EditJobData>();
      json['data'].forEach((v) {
        data.add(new EditJobData.fromJson(v));
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
