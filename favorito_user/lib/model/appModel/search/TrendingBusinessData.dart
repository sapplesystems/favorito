import 'package:favorito_user/model/appModel/Business/SubCategory.dart';

class TrendingBusinessData {
  int id;
  String businessId;
  int avgRating;
  int distance;
  int businessCategoryId;
  String businessName;
  String townCity;
  String photo;
  String businessStatus;
  List<SubCategory> subCategory;

  TrendingBusinessData(
      {this.id,
      this.businessId,
      this.avgRating,
      this.distance,
      this.businessCategoryId,
      this.businessName,
      this.townCity,
      this.photo,
      this.businessStatus,
      this.subCategory});

  TrendingBusinessData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    avgRating = json['avg_rating'];
    distance = json['distance'];
    businessCategoryId = json['business_category_id'];
    businessName = json['business_name'];
    townCity = json['town_city'];
    photo = json['photo'];
    businessStatus = json['business_status'];
    if (json['sub_category'] != null) {
      subCategory = new List<SubCategory>();
      json['sub_category'].forEach((v) {
        subCategory.add(new SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['avg_rating'] = this.avgRating;
    data['distance'] = this.distance;
    data['business_category_id'] = this.businessCategoryId;
    data['business_name'] = this.businessName;
    data['town_city'] = this.townCity;
    data['photo'] = this.photo;
    data['business_status'] = this.businessStatus;
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
