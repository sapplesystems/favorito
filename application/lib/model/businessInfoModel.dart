import 'package:Favorito/model/SubCategories.dart';

class businessInfoModel {
  String status;
  String message;
  DdVerbose ddVerbose;
  Data data;

  businessInfoModel({this.status, this.message, this.ddVerbose, this.data});

  businessInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    ddVerbose = json['dd_verbose'] != null
        ? new DdVerbose.fromJson(json['dd_verbose'])
        : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.ddVerbose != null) {
      data['dd_verbose'] = this.ddVerbose.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class DdVerbose {
  List<String> staticPaymentMethod;
  List<int> staticPriceRange;
  List<TagList> tagList;
  List<AttributeList> attributeList;

  DdVerbose(
      {this.staticPaymentMethod,
      this.staticPriceRange,
      this.tagList,
      this.attributeList});

  DdVerbose.fromJson(Map<String, dynamic> json) {
    staticPaymentMethod = json['static_payment_method'].cast<String>();
    staticPriceRange = json['static_price_range'].cast<int>();
    if (json['tag_list'] != null) {
      tagList = new List<TagList>();
      json['tag_list'].forEach((v) {
        tagList.add(new TagList.fromJson(v));
      });
    }
    if (json['attribute_list'] != null) {
      attributeList = new List<AttributeList>();
      json['attribute_list'].forEach((v) {
        attributeList.add(new AttributeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['static_payment_method'] = this.staticPaymentMethod;
    data['static_price_range'] = this.staticPriceRange;
    if (this.tagList != null) {
      data['tag_list'] = this.tagList.map((v) => v.toJson()).toList();
    }
    if (this.attributeList != null) {
      data['attribute_list'] =
          this.attributeList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TagList {
  int id;
  String tagName;

  TagList({this.id, this.tagName});

  TagList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tagName = json['tag_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tag_name'] = this.tagName;
    return data;
  }
}

class AttributeList {
  int id;
  String attributeName;

  AttributeList({this.id, this.attributeName});

  AttributeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeName = json['attribute_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['attribute_name'] = this.attributeName;
    return data;
  }
}

class Data {
  int businessInformationId;
  String businessId;
  int categoryId;
  String categoryName;
  String subCategoriesId;
  String subCategoriesName;
  List<String> tags;
  String priceRange;
  List<String> paymentMethod;
  List<String> attributes;
  List<SubCategories> subCategories;
  List<String> photos;

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
    businessInformationId = json['business_information_id'];
    businessId = json['business_id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    subCategoriesId = json['sub_categories_id'];
    subCategoriesName = json['sub_categories_name'];
    tags = json['tags'].cast<String>();
    priceRange = json['price_range'];
    paymentMethod = json['payment_method'].cast<String>();
    attributes = json['attributes'].cast<String>();
    if (json['sub_categories'] != null) {
      subCategories = new List<SubCategories>();
      json['sub_categories'].forEach((v) {
        subCategories.add(new SubCategories.fromJson(v));
      });
    }
    photos = json['photos'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_information_id'] = this.businessInformationId;
    data['business_id'] = this.businessId;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['sub_categories_id'] = this.subCategoriesId;
    data['sub_categories_name'] = this.subCategoriesName;
    data['tags'] = this.tags;
    data['price_range'] = this.priceRange;
    data['payment_method'] = this.paymentMethod;
    data['attributes'] = this.attributes;
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    data['photos'] = this.photos;
    return data;
  }
}

