import 'package:Favorito/model/menu/Category.dart';

class MenuVerbose {
  String status;
  String message;
  Data data;

  MenuVerbose({this.status, this.message, this.data});

  MenuVerbose.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Category> category;

  Data({this.category});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['category'] != null) {
      category = new List<Category>();
      json['category'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<String> getCategoryName() {
    List<String> val = <String>[];
    for (var v in this.category) {
      val.add(v.categoryName);
    }
    return val;
  }

  List<int> getCategoryId() {
    List<int> val = <int>[];
    for (var v in this.category) {
      val.add(v.categoryId);
    }
    return val;
  }

  String getIdByName(String name) {
    String val;
    for (var v in this.category) {
      if (name == v.categoryName) {
        val = v.id.toString();
      }
    }
    print("val$val");
    return val;
  }

  String getNameById(String id) {
    String name;
    for (var v in this.category) {
      print("idIs:${id}:${v.id}");
      if (id.toString() == v.id.toString()) name = v.categoryName;
    }
    return name;
  }
}
