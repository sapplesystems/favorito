import 'package:Favorito/model/PhotoData.dart';

class highLightesData {
  String status;
  String message;
  Data data;

  highLightesData({this.status, this.message, this.data});

  highLightesData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String highlightTitle;
  String highlightDesc;
  List<PhotoData> photos;

  Data({this.highlightTitle, this.highlightDesc, this.photos});

  Data.fromJson(Map<String, dynamic> json) {
    highlightTitle = json['highlight_title'];
    highlightDesc = json['highlight_desc'];
    if (json['photos'] != null) {
      photos = new List<PhotoData>();
      json['photos'].forEach((v) {
        photos.add(new PhotoData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['highlight_title'] = this.highlightTitle;
    data['highlight_desc'] = this.highlightDesc;
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
