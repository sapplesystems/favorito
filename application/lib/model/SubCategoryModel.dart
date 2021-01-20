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

  List<String> getAllSubCategory() {
    List<String> list = [];
    for (var v in this.data) {
      list.add(v.categoryName);
    }
    return list;
  }

  int getSubCategoryId(String name) {
    for (var v in this.data) {
      if (name == v.categoryName) return v.id;
    }
  }

  List<int> getAllSubCategoryId(List<String> selected) {
    List<int> list = [];
    for (var v in selected) {
      list.add(getSubCategoryId(v));
    }
    return list;
  }
}
