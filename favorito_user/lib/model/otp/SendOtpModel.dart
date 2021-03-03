import 'package:favorito_user/model/otp/OtpData.dart';

class SendOtpModel {
  String status;
  String message;
  List<OtpData> data;

  SendOtpModel({this.status, this.message, this.data});

  SendOtpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<OtpData>();
      json['data'].forEach((v) {
        data.add(new OtpData.fromJson(v));
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
