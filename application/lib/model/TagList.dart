class TagList {
  int id;
  String tagName;
  bool isSetected;

  TagList({this.id, this.tagName, this.isSetected = false});

  TagList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tagName = json['tag_name'];
    isSetected = json['isSetected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tag_name'] = this.tagName;
    data['isSetected'] = this.isSetected;
    return data;
  }
}
