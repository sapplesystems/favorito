class MenuItemModel {
  int id;
  String title;
  int price;
  String description;
  String type;
  var photoId;
  var photos;

  MenuItemModel(
      {this.id,
      this.title,
      this.price,
      this.description,
      this.type,
      this.photoId,
      this.photos});

  MenuItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    type = json['type'];
    photoId = json['photo_id'] ?? '';
    photos = json['photos'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['type'] = this.type;
    data['photo_id'] = this.photoId;
    data['photos'] = this.photos;
    return data;
  }
}
