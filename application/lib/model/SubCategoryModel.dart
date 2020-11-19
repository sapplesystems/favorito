import 'package:Favorito/model/SubCategories.dart';

class SubCategoryModel {
  String status;
  String message;
  List<SubCategories> data;

  SubCategoryModel({this.status, this.message, this.data});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<SubCategories>();
      json['data'].forEach((v) {
        data.add(new SubCategories.fromJson(v));
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
