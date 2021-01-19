class MenuBaseModel {
  String status;
  String message;
  List<Data> data;

  MenuBaseModel({this.status, this.message, this.data});

  MenuBaseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  int categoryId;
  String categoryName;
  List<Items> items;

  Data({this.categoryId, this.categoryName, this.items});

  Data.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
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
  bool isActivated;
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
      this.isActivated,
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
    isActivated = json['is_activated']==1?true:false;
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
    data['is_activated'] = this.isActivated;
    data['photo_id'] = this.photoId;
    data['photos'] = this.photos;
    return data;
  }
}
