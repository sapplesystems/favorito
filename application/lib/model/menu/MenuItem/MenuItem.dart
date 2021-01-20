import 'package:Favorito/model/menu/MenuItem/ItemData.dart';

class MenuItemModel {
  String status;
  String message;
  List<ItemData> data;

  MenuItemModel({this.status, this.message, this.data});

  MenuItemModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<ItemData>();
      json['data'].forEach((v) {
        data.add(new ItemData.fromJson(v));
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
