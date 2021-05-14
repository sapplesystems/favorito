// import 'package:favorito_user/model/appModel/Menu/Customization.dart/CustomizationModel.dart';

// class CustomizationModels {
//   int attributeId;
//   String attributeName;
//   int multiSelection;
//   List<CustomizationItemModel> customizationOption;

//   CustomizationModel(
//       {this.attributeId,
//       this.attributeName,
//       this.multiSelection,
//       this.customizationOption});

//   CustomizationModel.fromJson(Map<String, dynamic> json) {
//     attributeId = json['attribute_id'];
//     attributeName = json['attribute_name'];
//     multiSelection = json['multi_selection'];
//     if (json['customization_option'] != null) {
//       customizationOption = [];
//       json['customization_option'].forEach((v) {
//         customizationOption.add(new CustomizationItemModel.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['attribute_id'] = this.attributeId;
//     data['attribute_name'] = this.attributeName;
//     data['multi_selection'] = this.multiSelection;
//     if (this.customizationOption != null) {
//       data['customization_option'] =
//           this.customizationOption.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
