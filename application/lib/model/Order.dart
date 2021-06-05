class OrderData {
  String orderId;
  String name;
  String mobile;
  String notes;
  String orderType;
  int totalAmount;
  String orderStatus;
  String orderDate;
  String paymentType;

  OrderData(
      {this.orderId,
      this.name,
      this.mobile,
      this.notes,
      this.orderType,
      this.totalAmount,
      this.orderStatus,
      this.orderDate,
      this.paymentType});

  OrderData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    name = json['name'];
    mobile = json['mobile'];
    notes = json['notes'];
    orderType = json['order_type'];
    totalAmount = json['total_amount'];
    orderStatus = json['order_status'];
    orderDate = json['order_date'];
    paymentType = json['payment_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['notes'] = this.notes;
    data['order_type'] = this.orderType;
    data['total_amount'] = this.totalAmount;
    data['order_status'] = this.orderStatus;
    data['order_date'] = this.orderDate;
    data['payment_type'] = this.paymentType;
    return data;
  }
}
