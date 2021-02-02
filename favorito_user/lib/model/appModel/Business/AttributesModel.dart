class Attributes {
  String attributeName;

  Attributes({this.attributeName});

  Attributes.fromJson(Map<String, dynamic> json) {
    attributeName = json['attribute_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attribute_name'] = this.attributeName;
    return data;
  }

  String toString() => 'Attributes{attributeName:$attributeName}';
}
