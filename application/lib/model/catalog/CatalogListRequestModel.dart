class CatalogListRequestModel {
  String status;
  String message;
  List<Data> data;

  CatalogListRequestModel({this.status, this.message, this.data});

  CatalogListRequestModel.fromJson(Map<String, dynamic> json) {
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
  String photo;

  Data({this.id, this.catalogTitle, this.photo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catalogTitle = json['catalog_title'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['catalog_title'] = this.catalogTitle;
    data['photo'] = this.photo;
    return data;
  }
}
