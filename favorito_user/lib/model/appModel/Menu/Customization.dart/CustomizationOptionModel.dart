class CustomizationOptionModel {
  int idAttribute;
  int optionId;
  String name;

  bool isSelected = false;

  CustomizationOptionModel({this.idAttribute, this.optionId, this.name});

  CustomizationOptionModel.fromJson(Map<String, dynamic> json) {
    idAttribute = json['id_attribute'];
    optionId = json['option_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_attribute'] = this.idAttribute;
    data['option_id'] = this.optionId;
    data['name'] = this.name;
    return data;
  }
}
