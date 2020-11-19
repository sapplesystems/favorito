import 'package:Favorito/model/catalog/Catalog.dart';

class CatalogListRequestModel {
  String status;
  String message;
  List<CatalogModel> data;

  CatalogListRequestModel({this.status, this.message, this.data});

  CatalogListRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<CatalogModel>();
      json['data'].forEach((v) {
        data.add(CatalogModel.fromJson(v));
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

