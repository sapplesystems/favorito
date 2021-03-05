import 'package:Favorito/model/waitlist/WaitlistModel.dart';

class WaitlistListModel {
  String status;
  String message;
  List<WaitlistModel> data;

  WaitlistListModel({this.status, this.message, this.data});

  WaitlistListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<WaitlistModel>();
      json['data']?.forEach((v) {
        data.add(new WaitlistModel.fromJson(v));
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
