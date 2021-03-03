class CatalogModel {
  int id;
  String catalogTitle;
  var catalogPrice;
  String catalogDesc;
  String productUrl;
  String productId;
  String photosId;
  String photos;

  CatalogModel(
      {this.id,
      this.catalogTitle,
      this.catalogPrice,
      this.catalogDesc,
      this.productUrl,
      this.productId,
      this.photosId,
      this.photos});

  CatalogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catalogTitle = json['catalog_title'];
    catalogPrice = json['catalog_price'];
    catalogDesc = json['catalog_desc'];
    productUrl = json['product_url'];
    productId = json['product_id'];
    photosId = json['photos_id'];
    photos = json['photos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> Catalog = new Map<String, dynamic>();
    Catalog['id'] = this.id;
    Catalog['catalog_title'] = this.catalogTitle;
    Catalog['catalog_price'] = this.catalogPrice;
    Catalog['catalog_desc'] = this.catalogDesc;
    Catalog['product_url'] = this.productUrl;
    Catalog['product_id'] = this.productId;
    Catalog['photos_id'] = this.photosId;
    Catalog['photos'] = this.photos;
    return Catalog;
  }
}
