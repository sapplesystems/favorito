class ReviewintroModel {
  String status;
  String message;
  Data data;

  ReviewintroModel({this.status, this.message, this.data});

  ReviewintroModel.fromJson(Map<String, dynamic> json) {
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
  String businessId;
  TotalRating totalRating;
  TotalReview totalReview;
  AvgRatingData avgRatingData;
  RatingsByPoints ratingsByPoints;

  Data(
      {this.businessId,
      this.totalRating,
      this.totalReview,
      this.avgRatingData,
      this.ratingsByPoints});

  Data.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    totalRating = json['total_rating'] != null
        ? new TotalRating.fromJson(json['total_rating'])
        : null;
    totalReview = json['total_review'] != null
        ? new TotalReview.fromJson(json['total_review'])
        : null;
    avgRatingData = json['avg_rating_data'] != null
        ? new AvgRatingData.fromJson(json['avg_rating_data'])
        : null;
    ratingsByPoints = json['ratings_by_points'] != null
        ? new RatingsByPoints.fromJson(json['ratings_by_points'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    if (this.totalRating != null) {
      data['total_rating'] = this.totalRating.toJson();
    }
    if (this.totalReview != null) {
      data['total_review'] = this.totalReview.toJson();
    }
    if (this.avgRatingData != null) {
      data['avg_rating_data'] = this.avgRatingData.toJson();
    }
    if (this.ratingsByPoints != null) {
      data['ratings_by_points'] = this.ratingsByPoints.toJson();
    }
    return data;
  }
}

class TotalRating {
  int totalRatings;

  TotalRating({this.totalRatings});

  TotalRating.fromJson(Map<String, dynamic> json) {
    totalRatings = json['total_ratings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_ratings'] = this.totalRatings;
    return data;
  }
}

class TotalReview {
  int totalReviews;

  TotalReview({this.totalReviews});

  TotalReview.fromJson(Map<String, dynamic> json) {
    totalReviews = json['total_reviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_reviews'] = this.totalReviews;
    return data;
  }
}

class AvgRatingData {
  var avgRating;

  AvgRatingData({this.avgRating});

  AvgRatingData.fromJson(Map<String, dynamic> json) {
    avgRating = json['avg_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avg_rating'] = this.avgRating;
    return data;
  }
}

class RatingsByPoints {
  int rating1;
  int rating2;
  int rating3;
  int rating4;
  int rating5;

  RatingsByPoints(
      {this.rating1, this.rating2, this.rating3, this.rating4, this.rating5});

  RatingsByPoints.fromJson(Map<String, dynamic> json) {
    rating1 = json['rating_1'];
    rating2 = json['rating_2'];
    rating3 = json['rating_3'];
    rating4 = json['rating_4'];
    rating5 = json['rating_5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating_1'] = this.rating1;
    data['rating_2'] = this.rating2;
    data['rating_3'] = this.rating3;
    data['rating_4'] = this.rating4;
    data['rating_5'] = this.rating5;
    return data;
  }
}
