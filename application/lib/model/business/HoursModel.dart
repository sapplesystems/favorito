import 'package:Favorito/model/business/BusinessProfileModel.dart';

class HoursModel {
  String status;
  String message;
  List<Hours> data;

  HoursModel({this.status, this.message, this.data});

  HoursModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Hours>();
      json['data'].forEach((v) {
        data.add(new Hours.fromJson(v));
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
