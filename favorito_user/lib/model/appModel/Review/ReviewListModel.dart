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
  String userId;
  int self;
  String businessId;
  String reviews;
  int parentId;
  String name;
  String photo;
  String userReview;
  String createdAt;
  String businessDate;
  String businessReview;
  var rating;
  int totalReviews;

  ReviewData1(
      {this.rootId,
      this.userId,
      this.self,
      this.businessId,
      this.reviews,
      this.parentId,
      this.name,
      this.photo,
      this.userReview,
      this.createdAt,
      this.businessDate,
      this.businessReview,
      this.rating,
      this.totalReviews});

  ReviewData1.fromJson(Map<String, dynamic> json) {
    rootId = json['root_id'];
    userId = json['user_id'];
    self = json['self'];
    businessId = json['business_id'];
    reviews = json['reviews'];
    parentId = json['parent_id'];
    name = json['name'];
    photo = json['photo'];
    userReview = json['user_review'];
    createdAt = json['created_at'];
    businessDate = json['business_date'];
    businessReview = json['business_review'];
    rating = json['rating'];
    totalReviews = json['total_reviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['root_id'] = this.rootId;
    data['user_id'] = this.userId;
    data['self'] = this.self;
    data['business_id'] = this.businessId;
    data['reviews'] = this.reviews;
    data['parent_id'] = this.parentId;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['user_review'] = this.userReview;
    data['created_at'] = this.createdAt;
    data['business_date'] = this.businessDate;
    data['business_review'] = this.businessReview;
    data['rating'] = this.rating;
    data['total_reviews'] = this.totalReviews;
    return data;
  }
}
