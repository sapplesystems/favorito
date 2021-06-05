// import 'package:Favorito/model/Detail.dart';
// import 'package:Favorito/model/Order.dart';

// class OrderData {
//   Order order;
//   List<Detail> detail;

//   OrderData({this.order, this.detail});

//   OrderData.fromJson(Map<String, dynamic> json) {
//     order = json['order'] != null ? new Order.fromJson(json['order']) : null;
//     if (json['detail'] != null) {
//       detail = new List<Detail>();
//       json['detail'].forEach((v) => detail.add(new Detail.fromJson(v)));
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> Orderdata = new Map<String, dynamic>();
//     if (this.order != null) {
//       Orderdata['order'] = this.order.toJson();
//     }
//     if (this.detail != null) {
//       Orderdata['detail'] = this.detail.map((v) => v.toJson()).toList();
//     }
//     return Orderdata;
//   }
// }
