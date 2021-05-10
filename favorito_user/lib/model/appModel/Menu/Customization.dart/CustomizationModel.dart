import 'package:favorito_user/model/appModel/Menu/Customization.dart/AttributeModel.dart';

class CustomizationItemModel {
  String status;
  String message;
  List<AttributeModel> data;

  CustomizationItemModel({this.status, this.message, this.data});

  CustomizationItemModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new AttributeModel.fromJson(v));
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
