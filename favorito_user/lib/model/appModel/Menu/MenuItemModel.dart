import 'package:favorito_user/model/appModel/Menu/Customization.dart/CustomizationModel.dart';

class MenuItemModel {
  int id;
  String title;
  var price;
  String description;
  String type;
  var photoId;
  var photos;
  var businessId;
  int quantity;
  int maxQtyPerOrder;
  int catagoryId;
  var tax;
  int menuCategoryId;
  String itenCustomizationSum;
  int isCustomizable;
  CustomizationItemModel customizationItemModel = CustomizationItemModel();
  MenuItemModel(
      {this.id,
      this.title,
      this.price,
      this.description,
      this.type,
      this.photoId,
      this.photos,
      this.businessId,
      this.quantity,
      this.maxQtyPerOrder,
      this.catagoryId,
      this.customizationItemModel,
      this.tax,
      this.itenCustomizationSum,
      this.isCustomizable,
      this.menuCategoryId});

  MenuItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    type = json['type'];
    photoId = json['photo_id'] ?? [];
    maxQtyPerOrder = json['max_qty_per_order'] ?? [];
    photos = json['photos'] ?? [];
    businessId = json['business_id'];
    tax = json['tax'];
    isCustomizable = json['is_customizable'];
    menuCategoryId = json['menu_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['max_qty_per_order'] = this.maxQtyPerOrder;
    data['type'] = this.type;
    data['photo_id'] = this.photoId;
    data['photos'] = this.photos;
    data['business_id'] = this.businessId;
    data['tax'] = this.tax;
    data['is_customizable'] = this.isCustomizable;
    data['menu_category_id'] = this.menuCategoryId;
    return data;
  }
}
