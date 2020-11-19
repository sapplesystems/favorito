import 'package:Favorito/model/OrderDetail.dart';

class orderListModel {
  String status;
  String message;
  List<OrderData> data;

  orderListModel({this.status, this.message, this.data});

  orderListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<OrderData>();
      json['data'].forEach((v) {
        data.add(new OrderData.fromJson(v));
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
