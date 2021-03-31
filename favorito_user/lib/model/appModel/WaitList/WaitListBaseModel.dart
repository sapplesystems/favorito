import 'package:favorito_user/model/appModel/WaitList/WaitListDataModel.dart';

class WaitListBaseModel {
  String status;
  String message;
  List<WaitListDataModel> data;

  WaitListBaseModel({this.status, this.message, this.data});

  WaitListBaseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new WaitListDataModel.fromJson(v));
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
