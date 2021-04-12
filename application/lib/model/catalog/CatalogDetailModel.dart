class CatalogDetailModel {
  String status;
  String message;
  List<Data> data;

  CatalogDetailModel({this.status, this.message, this.data});

  CatalogDetailModel.fromJson(Map<String, dynamic> json) {
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
  int id;
  String catalogTitle;
  var catalogPrice;
  String catalogDesc;
  String productUrl;
  String productId;
  String photosId;
  String photos;

  Data(
      {this.id,
      this.catalogTitle,
      this.catalogPrice,
      this.catalogDesc,
      this.productUrl,
      this.productId,
      this.photosId,
      this.photos});

  Data.fromJson(Map<String, dynamic> json) {
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
