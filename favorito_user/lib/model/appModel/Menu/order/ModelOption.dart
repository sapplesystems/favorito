class ModelOption {
  String status;
  String message;
  ModelOptionData data;

  ModelOption({this.status, this.message, this.data});

  ModelOption.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new ModelOptionData.fromJson(json['data'])
        : null;
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

class ModelOptionData {
  int acceptingOrder;
  List<OrderType> orderType;
  List<String> paymentType;

  ModelOptionData({this.acceptingOrder, this.orderType, this.paymentType});

  ModelOptionData.fromJson(Map<String, dynamic> json) {
    if (json['order_type'] != null) {
      orderType = [];
      json['order_type'].forEach((v) {
        orderType.add(new OrderType.fromJson(v));
      });
    }
    paymentType = json['payment_type'].cast<String>();
    acceptingOrder = json['accepting_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderType != null) {
      data['order_type'] = this.orderType.map((v) => v.toJson()).toList();
    }
    data['payment_type'] = this.paymentType;
    data['accepting_order'] = this.acceptingOrder;
    return data;
  }
}

class OrderType {
  String attribute;
  int minimumBill;
  int packagingCharge;

  OrderType({this.attribute, this.minimumBill, this.packagingCharge});

  OrderType.fromJson(Map<String, dynamic> json) {
    attribute = json['attribute'];
    minimumBill = json['minimum_bill'];
    packagingCharge = json['packaging_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attribute'] = this.attribute;
    data['minimum_bill'] = this.minimumBill;
    data['packaging_charge'] = this.packagingCharge;
    return data;
  }
}
