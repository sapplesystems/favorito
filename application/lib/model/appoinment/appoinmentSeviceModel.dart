import 'package:Favorito/model/appoinment/PersonList.dart';
import 'package:Favorito/model/appoinment/ServiceData.dart';

class appoinmentSeviceModel {
  String status;
  String message;
  AppServData data;

  appoinmentSeviceModel({this.status, this.message, this.data});

  appoinmentSeviceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new AppServData.fromJson(json['data']) : null;
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

class AppServData {
  List<PersonList> personList;
  List<ServiceList> serviceList;

  AppServData({this.personList, this.serviceList});

  AppServData.fromJson(Map<String, dynamic> json) {
    if (json['person_list'] != null) {
      personList = new List<PersonList>();
      json['person_list'].forEach((v) {
        personList.add(new PersonList.fromJson(v));
      });
    }
    if (json['service_list'] != null) {
      serviceList = new List<ServiceList>();
      json['service_list'].forEach((v) {
        serviceList.add(new ServiceList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.personList != null) {
      data['person_list'] = this.personList.map((v) => v.toJson()).toList();
    }
    if (this.serviceList != null) {
      data['service_list'] = this.serviceList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
