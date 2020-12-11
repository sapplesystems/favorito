import 'package:favorito_user/model/appModel/search/TrendingBusinessData.dart';

class TrendingBusinessModel {
  String status;
  String message;
  List<TrendingBusinessData> data;

  TrendingBusinessModel({this.status, this.message, this.data});

  TrendingBusinessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<TrendingBusinessData>();
      json['data'].forEach((v) {
        data.add(new TrendingBusinessData.fromJson(v));
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
