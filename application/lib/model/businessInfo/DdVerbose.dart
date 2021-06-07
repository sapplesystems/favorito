import 'package:Favorito/model/AttributeList.dart';
import 'package:Favorito/model/TagList.dart';

class DdVerbose {
  List<String> staticPaymentMethod;
  List<String> staticPriceRange;
  List<TagList> tagList;
  List<AttributeList> attributeList;

  DdVerbose(
      {this.staticPaymentMethod,
      this.staticPriceRange,
      this.tagList,
      this.attributeList});

  DdVerbose.fromJson(Map<String, dynamic> json) {
    staticPaymentMethod = json['static_payment_method']?.cast<String>();
    staticPriceRange = json['static_price_range']?.cast<String>();
    if (json['tag_list'] != null) {
      tagList = [];
      json['tag_list'].forEach((v) {
        tagList.add(new TagList.fromJson(v));
      });
    }
    if (json['attribute_list'] != null) {
      attributeList = [];
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
