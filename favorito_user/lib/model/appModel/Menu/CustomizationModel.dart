import 'package:favorito_user/model/appModel/Menu/CustomizationOptionModel.dart';

class CustomizationItemModel {
  String status;
  String message;
  List<Data> data;

  CustomizationItemModel({this.status, this.message, this.data});

  CustomizationItemModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  int attributeId;
  String attributeName;
  int multiSelection;
  List<CustomizationOptionModel> customizationOption;

  Data(
      {this.attributeId,
      this.attributeName,
      this.multiSelection,
      this.customizationOption});

  Data.fromJson(Map<String, dynamic> json) {
    attributeId = json['attribute_id'];
    attributeName = json['attribute_name'];
    multiSelection = json['multi_selection'];
    if (json['customization_option'] != null) {
      customizationOption = [];
      json['customization_option'].forEach((v) {
        customizationOption.add(new CustomizationOptionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attribute_id'] = this.attributeId;
    data['attribute_name'] = this.attributeName;
    data['multi_selection'] = this.multiSelection;
    if (this.customizationOption != null) {
      data['customization_option'] =
          this.customizationOption.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
