class Order {
  String orderId;
  String name;
  String mobile;
  String notes;
  String orderType;
  double totalAmount;
  int isAccepted;
  int isRejected;
  String orderDate;
  String payType;

  Order(
      {this.orderId,
      this.name,
      this.mobile,
      this.notes,
      this.orderType,
      this.totalAmount,
      this.isAccepted,
      this.isRejected,
      this.orderDate,
      this.payType});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    name = json['name'];
    mobile = json['mobile'];
    notes = json['notes'];
    orderType = json['order_type'];
    totalAmount = json['total_amount'];
    isAccepted = json['is_accepted'];
    isRejected = json['is_rejected'];
    orderDate = json['order_date'];
    payType = json['payment_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['notes'] = this.notes;
    data['order_type'] = this.orderType;
    data['total_amount'] = this.totalAmount;
    data['is_accepted'] = this.isAccepted;
    data['is_rejected'] = this.isRejected;
    data['order_date'] = this.orderDate;
    data['payment_type'] = this.payType;
    return data;
  }
}
