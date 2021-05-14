class OrderDetail {
  int itemId;
  String item;
  int qty;

  OrderDetail({this.itemId, this.item, this.qty});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    item = json['item'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_id'] = this.itemId;
    data['item'] = this.item;
    data['qty'] = this.qty;
    return data;
  }
}
