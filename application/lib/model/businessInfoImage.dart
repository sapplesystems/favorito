import 'package:Favorito/model/PhotoData.dart';

class businessInfoImage {
  String status;
  String message;
  var catalogId;
  List<PhotoData> data;

  businessInfoImage({this.status, this.message, this.data, this.catalogId});

  businessInfoImage.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    catalogId = json['catalog_id'];
    if (json['data'] != null) {
      data = new List<PhotoData>();
      json['data'].forEach((v) {
        data.add(new PhotoData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['catalog_id'] = this.catalogId;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
