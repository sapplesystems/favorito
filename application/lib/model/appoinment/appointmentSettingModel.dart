import 'package:Favorito/model/appoinment/SettingData.dart';

class appointmentSettingModel {
  String status;
  String message;
  List<SettingData> data;

  appointmentSettingModel({this.status, this.message, this.data});

  appointmentSettingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<SettingData>();
      json['data'].forEach((v) {
        data.add(new SettingData.fromJson(v));
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
