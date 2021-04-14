class ReviewListModel {
  String status;
  String message;
  List<ReviewListData> data;

  ReviewListModel({this.status, this.message, this.data});

  ReviewListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<ReviewListData>();
      json['data'].forEach((v) {
        data.add(new ReviewListData.fromJson(v));
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

class ReviewListData {
  int id;
  String fullName;
  String userId;
  String businessId;
  int rating;
  String reviews;
  String reviewDate;
  String reviewAt;

  ReviewListData(
      {this.id,
      this.fullName,
      this.userId,
      this.businessId,
      this.rating,
      this.reviews,
      this.reviewDate,
      this.reviewAt});

  ReviewListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    userId = json['user_id'];
    businessId = json['business_id'];
    rating = json['rating'];
    reviews = json['reviews'];
    reviewDate = json['review_date'];
    reviewAt = json['review_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['user_id'] = this.userId;
    data['business_id'] = this.businessId;
    data['rating'] = this.rating;
    data['reviews'] = this.reviews;
    data['review_date'] = this.reviewDate;
    data['review_at'] = this.reviewAt;
    return data;
  }
}
