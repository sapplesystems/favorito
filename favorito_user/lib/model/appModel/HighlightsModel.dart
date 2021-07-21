class HighlightsModel {
  String status;
  String message;
  HighlightData data;

  HighlightsModel({this.status, this.message, this.data});

  HighlightsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? new HighlightData.fromJson(json['data']) : null;
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

class HighlightData {
  String highlightTitle;
  String highlightDesc;
  List<Photos> photos;

  HighlightData({this.highlightTitle, this.highlightDesc, this.photos});

  HighlightData.fromJson(Map<String, dynamic> json) {
    highlightTitle = json['highlight_title'];
    highlightDesc = json['highlight_desc'];
    if (json['photos'] != null) {
      photos = new List<Photos>();
      json['photos'].forEach((v) {
        photos.add(new Photos.fromJson(v));
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

class Photos {
  int id;
  String photo;

  Photos({this.id, this.photo});

  Photos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo'] = this.photo;
    return data;
  }
}
