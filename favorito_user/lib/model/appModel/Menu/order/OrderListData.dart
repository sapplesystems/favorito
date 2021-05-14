import 'package:favorito_user/model/appModel/Menu/order/OrderDetail.dart';

class OrderListData {
  String businessId;
  String businessName;
  String businessPhoto;
  String address;
  String city;
  String orderId;
  String name;
  String mobile;
  String notes;
  String orderType;
  String orderStatus;
  var totalAmount;
  String paymentType;
  String createdAt;
  List<OrderDetail> orderDetail;

  OrderListData(
      {this.businessId,
      this.businessName,
      this.businessPhoto,
      this.address,
      this.city,
      this.orderId,
      this.name,
      this.mobile,
      this.notes,
      this.orderType,
      this.orderStatus,
      this.totalAmount,
      this.paymentType,
      this.createdAt,
      this.orderDetail});

  OrderListData.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    businessName = json['business_name'];
    businessPhoto = json['business_photo'];
    address = json['address'];
    city = json['city'];
    orderId = json['order_id'];
    name = json['name'];
    mobile = json['mobile'];
    notes = json['notes'];
    orderType = json['order_type'];
    orderStatus = json['order_status'];
    totalAmount = json['total_amount'];
    paymentType = json['payment_type'];
    createdAt = json['created_at'];
    if (json['order_detail'] != null) {
      orderDetail = [];
      json['order_detail'].forEach((v) {
        orderDetail.add(new OrderDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['business_name'] = this.businessName;
    data['business_photo'] = this.businessPhoto;
    data['address'] = this.address;
    data['city'] = this.city;
    data['order_id'] = this.orderId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['notes'] = this.notes;
    data['order_type'] = this.orderType;
    data['order_status'] = this.orderStatus;
    data['total_amount'] = this.totalAmount;
    data['payment_type'] = this.paymentType;
    data['created_at'] = this.createdAt;
    if (this.orderDetail != null) {
      data['order_detail'] = this.orderDetail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
