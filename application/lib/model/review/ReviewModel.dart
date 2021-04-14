class ReviewModel {
  String status;
  String message;
  List<Reviewdata> data;

  ReviewModel({this.status, this.message, this.data});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Reviewdata>();
      json['data'].forEach((v) {
        data.add(new Reviewdata.fromJson(v));
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

class Reviewdata {
  int id;
  String userName;
  String reviews;
  int parentId;
  int bToU;
  String createdAt;

  Reviewdata(
      {this.id,
      this.userName,
      this.reviews,
      this.parentId,
      this.bToU,
      this.createdAt});

  Reviewdata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    reviews = json['reviews'];
    parentId = json['parent_id'];
    bToU = json['b_to_u'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['reviews'] = this.reviews;
    data['parent_id'] = this.parentId;
    data['b_to_u'] = this.bToU;
    data['created_at'] = this.createdAt;
    return data;
  }
}
