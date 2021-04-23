import 'package:favorito_user/model/appModel/appointment/ServiceModel.dart';
import 'package:favorito_user/model/appModel/appointment/SettingModel.dart';

class AppSerModel {
  String status;
  String message;
  List<Data> data;

  AppSerModel({this.status, this.message, this.data});

  AppSerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  List<ServiceModel> service;
  List<SettingModel> setting;

  Data({this.service, this.setting});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['service'] != null) {
      service =[];
      json['service'].forEach((v) {
        service.add(new ServiceModel.fromJson(v));
      });
    }
    if (json['setting'] != null) {
      setting = [];
      json['setting'].forEach((v) {
        setting.add(new SettingModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.service != null) {
      data['service'] = this.service.map((v) => v.toJson()).toList();
    }
    if (this.setting != null) {
      data['setting'] = this.setting.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

