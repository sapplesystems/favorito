class CatlogData {
  var id;
  String catalogTitle;
  var catalogPrice;
  String catalogDesc;
  String productUrl;
  String productId;
  String photosId;
  String photos;

  CatlogData(
      {this.id,
      this.catalogTitle,
      this.catalogPrice,
      this.catalogDesc,
      this.productUrl,
      this.productId,
      this.photosId,
      this.photos});

  CatlogData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catalogTitle = json['catalog_title']??"Title";
    catalogPrice = json['catalog_price']??0;
    catalogDesc = json['catalog_desc']??"";
    productUrl = json['product_url'];
    productId = json['product_id'];
    photosId = json['photos_id'];
    photos = json['photos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['catalog_title'] = this.catalogTitle;
    data['catalog_price'] = this.catalogPrice;
    data['catalog_desc'] = this.catalogDesc;
    data['product_url'] = this.productUrl;
    data['product_id'] = this.productId;
    data['photos_id'] = this.photosId;
    data['photos'] = this.photos;
    return data;
  }
}
