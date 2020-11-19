import 'package:Favorito/model/TagList.dart';
import 'package:Favorito/model/businessInfoModel.dart';

class tagModel {
  String status;
  String message;
  List<TagList> data;

  tagModel({this.status, this.message, this.data});

  tagModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<TagList>();
      json['data'].forEach((v) {
        data.add(new TagList.fromJson(v));
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
