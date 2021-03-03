import 'package:Favorito/model/AttributeList.dart';
import 'package:Favorito/model/PhotoData.dart';
import 'package:Favorito/model/SubCategories.dart';
import 'package:Favorito/model/TagList.dart';

class BusinessInfoData {
  int businessInformationId;
  String businessId;
  int categoryId;
  String categoryName;
  String subCategoriesId;
  String subCategoriesName;
  List<TagList> tags;
  String priceRange;
  List<String> paymentMethod;
  List<AttributeList> attributes;
  List<SubCategories> subCategories;
  List<PhotoData> photos;

  BusinessInfoData(
      {this.businessInformationId,
      this.businessId,
      this.categoryId,
      this.categoryName,
      this.subCategoriesId,
      this.subCategoriesName,
      this.tags,
      this.priceRange,
      this.paymentMethod,
      this.attributes,
      this.subCategories,
      this.photos});

  BusinessInfoData.fromJson(Map<String, dynamic> json) {
    businessInformationId = json['business_information_id'];
    businessId = json['business_id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    subCategoriesId = json['sub_categories_id'];
    subCategoriesName = json['sub_categories_name'];
    if (json['tags'] != null) {
      tags = new List<TagList>();
      json['tags'].forEach((v) {
        tags.add(new TagList.fromJson(v));
      });
    }
    priceRange = json['price_range'];
    paymentMethod = json['payment_method'].cast<String>();
    if (json['attributes'] != null) {
      attributes = new List<AttributeList>();
      json['attributes'].forEach((v) {
        attributes.add(new AttributeList.fromJson(v));
      });
    }
    if (json['sub_categories'] != null) {
      subCategories = new List<SubCategories>();
      json['sub_categories'].forEach((v) {
        subCategories.add(new SubCategories.fromJson(v));
      });
    }
    if (json['photos'] != null) {
      photos = new List<PhotoData>();
      json['photos'].forEach((v) {
        photos.add(new PhotoData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_information_id'] = this.businessInformationId;
    data['business_id'] = this.businessId;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['sub_categories_id'] = this.subCategoriesId;
    data['sub_categories_name'] = this.subCategoriesName;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    data['price_range'] = this.priceRange;
    data['payment_method'] = this.paymentMethod;
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
