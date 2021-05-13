class ReviewListModel {
  String status;
  String message;
  List<ReviewData1> data;

  ReviewListModel({this.status, this.message, this.data});

  ReviewListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new ReviewData1.fromJson(v));
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

class ReviewData1 {
  int rootId;
  String businessId;
  String reviews;
  int parentId;
  String name;
  String photo;
  String createdAt;
  String userReview;
  String businessReview;
  int totalReviews;
  var rating;

  ReviewData1(
      {this.rootId,
      this.businessId,
      this.reviews,
      this.parentId,
      this.name,
      this.photo,
      this.createdAt,
      this.userReview,
      this.businessReview,
      this.totalReviews,
      this.rating});

  ReviewData1.fromJson(Map<String, dynamic> json) {
    rootId = json['root_id'];
    businessId = json['business_id'];
    reviews = json['reviews'];
    parentId = json['parent_id'];
    name = json['name'];
    photo = json['photo'];
    createdAt = json['created_at'];
    userReview = json['user_review'];
    businessReview = json['business_review'];
    totalReviews = json['total_reviews'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['root_id'] = this.rootId;
    data['business_id'] = this.businessId;
    data['reviews'] = this.reviews;
    data['parent_id'] = this.parentId;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['created_at'] = this.createdAt;
    data['user_review'] = this.userReview;
    data['business_review'] = this.businessReview;
    data['total_reviews'] = this.totalReviews;
    data['rating'] = this.rating;
    return data;
  }
}
