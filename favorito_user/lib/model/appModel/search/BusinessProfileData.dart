import 'package:favorito_user/model/appModel/Business/AttributesModel.dart';
import 'package:favorito_user/model/appModel/Business/RelationModel.dart';
import 'package:favorito_user/model/appModel/Business/SubCategory.dart';

class BusinessProfileData {
  int id;
  String businessId;
  String shortDesciption;
  String priceRange;
  String postalCode;
  String phone;
  String landline;
  String businessEmail;
  int totalReviews;
  String startHours;
  String endHours;
  int distance;
  int businessCategoryId;
  String businessName;
  String townCity;
  String photo;
  String businessStatus;
  int avgRating;
  List<Attributes> attributes;
  List<Relation> relation;
  List<SubCategory> subCategory;

  BusinessProfileData(
      {this.id,
      this.businessId,
      this.shortDesciption,
      this.priceRange,
      this.postalCode,
      this.phone,
      this.landline,
      this.businessEmail,
      this.totalReviews,
      this.startHours,
      this.endHours,
      this.distance,
      this.businessCategoryId,
      this.businessName,
      this.townCity,
      this.photo,
      this.businessStatus,
      this.avgRating,
      this.attributes,
      this.relation,
      this.subCategory});

  BusinessProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    shortDesciption = json['short_desciption'];
    priceRange = json['price_range'];
    postalCode = json['postal_code'];
    phone = json['phone'];
    landline = json['landline'];
    businessEmail = json['business_email'];
    totalReviews = json['total_reviews'];
    startHours = json['start_hours'];
    endHours = json['end_hours'];
    distance = json['distance'];
    businessCategoryId = json['business_category_id'];
    businessName = json['business_name'];
    townCity = json['town_city'];
    photo = json['photo'];
    businessStatus = json['business_status'];
    avgRating = json['avg_rating'];
    if (json['attributes'] != null) {
      attributes = new List<Attributes>();
      json['attributes'].forEach((v) {
        attributes.add(new Attributes.fromJson(v));
      });
    }
    if (json['relation'] != null) {
      relation = new List<Relation>();
      json['relation'].forEach((v) {
        relation.add(new Relation.fromJson(v));
      });
    }
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
    data['short_desciption'] = this.shortDesciption;
    data['price_range'] = this.priceRange;
    data['postal_code'] = this.postalCode;
    data['phone'] = this.phone;
    data['landline'] = this.landline;
    data['business_email'] = this.businessEmail;
    data['total_reviews'] = this.totalReviews;
    data['start_hours'] = this.startHours;
    data['end_hours'] = this.endHours;
    data['distance'] = this.distance;
    data['business_category_id'] = this.businessCategoryId;
    data['business_name'] = this.businessName;
    data['town_city'] = this.townCity;
    data['photo'] = this.photo;
    data['business_status'] = this.businessStatus;
    data['avg_rating'] = this.avgRating;
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    if (this.relation != null) {
      data['relation'] = this.relation.map((v) => v.toJson()).toList();
    }
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
