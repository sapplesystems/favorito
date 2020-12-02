import 'package:Favorito/model/CheckInData.dart';

class checkinsModel {
  String status;
  String message;
  List<CheckInData> data;

  checkinsModel({this.status, this.message, this.data});

  checkinsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<CheckInData>();
      json['data'].forEach((v) {
        data.add(new CheckInData.fromJson(v));
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
