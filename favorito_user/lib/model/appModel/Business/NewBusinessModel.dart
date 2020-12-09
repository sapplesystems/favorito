import 'package:favorito_user/model/appModel/Business/NewBusinessData.dart';

class NewBusinessModel {
  String status;
  String message;
  List<NewBusinessData> data;

  NewBusinessModel({this.status, this.message, this.data});

  NewBusinessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<NewBusinessData>();
      json['data'].forEach((v) {
        data.add(new NewBusinessData.fromJson(v));
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
