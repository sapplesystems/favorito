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
