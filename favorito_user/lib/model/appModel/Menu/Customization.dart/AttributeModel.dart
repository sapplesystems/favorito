import 'package:favorito_user/model/appModel/Menu/Customization.dart/CustomizationOptionModel.dart';

class AttributeModel {
  int attributeId;
  String attributeName;
  int multiSelection;
  var attributePrice;
  List<CustomizationOptionModel> customizationOption;

  AttributeModel(
      {this.attributeId,
      this.attributeName,
      this.multiSelection,
      this.attributePrice,
      this.customizationOption});

  AttributeModel.fromJson(Map<String, dynamic> json) {
    attributeId = json['attribute_id'];
    attributeName = json['attribute_name'];
    multiSelection = json['multi_selection'];
    attributePrice = json['customization_price'];
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
    data['customization_price'] = this.attributePrice;
    if (this.customizationOption != null) {
      data['customization_option'] =
          this.customizationOption.map((v) => v.toJson()).toList();
    }
    return data;
  }

  getSelectedOptions() {
    List<int> selectedOption = [];
    for (var r in customizationOption) {
      if (r?.isSelected) {
        selectedOption.add(r?.optionId);
      }
    }
    return selectedOption;
  }
}
