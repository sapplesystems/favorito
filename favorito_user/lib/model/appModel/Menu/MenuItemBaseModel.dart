import 'package:favorito_user/model/appModel/Menu/MenuItemModel.dart';

class MenuItemBaseModel {
  String status;
  String message;
  List<MenuItemModel> data;

  MenuItemBaseModel({this.status, this.message, this.data});

  MenuItemBaseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new MenuItemModel.fromJson(v));
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

  void setQuantity(int id, int quantity) {
    for (var v in this.data) {
      if (id == v.id) {
        v.quantity = quantity;
      }
    }
  }
}
