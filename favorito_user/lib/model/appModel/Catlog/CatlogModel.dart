import 'package:favorito_user/model/appModel/Catlog/CatlogData.dart';

class CatlogModel {
  String status;
  String message;
  List<CatlogData> data;

  CatlogModel({this.status, this.message, this.data});

  CatlogModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<CatlogData>();
      json['data'].forEach((v) {
        data.add(new CatlogData.fromJson(v));
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
