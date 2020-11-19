import 'package:Favorito/model/appoinment/RestrictionOnlyModel.dart';

class RestrictionModel {
  String status;
  String message;
  List<RestrictionOnlyModel> data;

  RestrictionModel({this.status, this.message, this.data});

  RestrictionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<RestrictionOnlyModel>();
      json['data'].forEach((v) {
        data.add(new RestrictionOnlyModel.fromJson(v));
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
