class SubCategories {
  int id;
  String categoryName;

  SubCategories({this.id, this.categoryName});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['sub_category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sub_category_name'] = this.categoryName;
    return data;
  }
}
