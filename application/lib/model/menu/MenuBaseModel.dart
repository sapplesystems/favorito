import 'package:Favorito/model/menu/Category.dart';

class MenuBaseModel {
  String status;
  String message;
  int businessType;
  List<Category> data;

  MenuBaseModel({this.status, this.message, this.businessType, this.data});

  MenuBaseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    businessType = json['business_type'];
    if (json['data'] != null) {
      data = new List<Category>();
      json['data'].forEach((v) => data.add(new Category.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['business_type'] = this.businessType;
    if (this.data != null)
      data['data'] = this.data.map((v) => v.toJson()).toList();

    return data;
  }

  String isAvailable(String id) {
    print("id is :$id");
    String val;
    for (var v in this.data) {
      if (v.categoryId.toString() == id) {
        val = v.outOfStock.toString();
        print("id is :$id");
      }
    }
    print("id is :$val");
    return val;
  }
}
