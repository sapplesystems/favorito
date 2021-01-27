class Category {
  int id;
  int categoryId;
  String categoryName;
  String details;
  var tax;
  String slotStartTime;
  String slotEndTime;
  String availableOn;
  int outOfStock;
  List<Items> items;

  Category(
      {this.id,
      this.categoryId,
      this.categoryName,
      this.details,
      this.tax,
      this.slotStartTime,
      this.slotEndTime,
      this.availableOn,
      this.outOfStock,
      this.items});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    details = json['details'];
    tax = json['tax'];
    slotStartTime = json['slot_start_time'];
    slotEndTime = json['slot_end_time'];
    availableOn = json['available_on'];
    outOfStock = json['out_of_stock'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
            items.add(new Items.fromJson(v));
          }) ??
          [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['details'] = this.details;
    data['tax'] = this.tax;
    data['slot_start_time'] = this.slotStartTime;
    data['slot_end_time'] = this.slotEndTime;
    data['available_on'] = this.availableOn;
    data['out_of_stock'] = this.outOfStock;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int id;
  String title;
  int price;
  String description;
  int quantity;
  String type;
  int maxQtyPerOrder;
  // bool isActivated;
  List photoId;
  List photos;

  Items(
      {this.id,
      this.title,
      this.price,
      this.description,
      this.quantity,
      this.type,
      this.maxQtyPerOrder,
      // this.isActivated,
      this.photoId,
      this.photos});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    quantity = json['quantity'];
    type = json['type'];
    maxQtyPerOrder = json['max_qty_per_order'];
    // isActivated = json['is_activated'] == 1 ? true : false;
    photoId = json['photo_id'] ?? [];
    photos = json['photos'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['type'] = this.type;
    data['max_qty_per_order'] = this.maxQtyPerOrder;
    // data['is_activated'] = this.isActivated;
    data['photo_id'] = this.photoId;
    data['photos'] = this.photos;
    return data;
  }
}
