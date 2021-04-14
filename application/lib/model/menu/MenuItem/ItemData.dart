import 'package:Favorito/model/menu/MenuItem/Photo.dart';

class ItemData {
  List<Photo> photo;
  String id;
  String businessId;
  String title;
  String menuCategoryId;
  String price;
  String description;
  String quantity;
  String type;
  String isActivated;
  String maxQtyPerOrder;
  // String out_of_stock

  ItemData(
      {this.photo,
      this.id,
      this.businessId,
      this.title,
      this.menuCategoryId,
      this.price,
      this.description,
      this.quantity,
      this.type,
      this.isActivated,
      this.maxQtyPerOrder});

  ItemData.fromJson(Map<String, dynamic> json) {
    if (json['photo'] != null) {
      photo = new List<Photo>();
      json['photo'].forEach((v) {
        photo.add(new Photo.fromJson(v));
      });
    } else {
      photo = [];
    }
    id = json['id'].toString();
    businessId = json['business_id'];
    title = json['title'];
    menuCategoryId = json['menu_category_id'].toString();
    price = json['price'].toString();
    description = json['description'];
    quantity = json['quantity'].toString();
    type = json['type'].toString();
    isActivated = json['is_activated'].toString();
    maxQtyPerOrder = json['max_qty_per_order'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.photo != null) {
      data['photo'] = this.photo.map((v) => v.toJson()).toList();
    } else {
      data['photo'] = [];
    }
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['title'] = this.title;
    data['menu_category_id'] = this.menuCategoryId;
    data['price'] = this.price;
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['type'] = this.type;
    data['is_activated'] = this.isActivated;
    data['max_qty_per_order'] = this.maxQtyPerOrder;
    return data;
  }
}
