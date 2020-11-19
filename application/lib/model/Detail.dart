class Detail {
  int categoryId;
  String categoryName;
  int itemId;
  int quantity;
  var price;
  var tax;
  var amount;

  Detail(
      {this.categoryId,
      this.categoryName,
      this.itemId,
      this.quantity,
      this.price,
      this.tax,
      this.amount});

  Detail.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    itemId = json['item_id'];
    quantity = json['quantity'];
    price = json['price'];
    tax = json['tax'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['item_id'] = this.itemId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['tax'] = this.tax;
    data['amount'] = this.amount;
    return data;
  }
}
