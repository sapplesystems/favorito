class PhotoData {
  var id;
  String type;
  String photo;

  PhotoData({this.id, this.type, this.photo});

  PhotoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['photo'] = this.photo;
    return data;
  }
}
