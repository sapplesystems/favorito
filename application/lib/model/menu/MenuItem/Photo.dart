class Photo {
  String photoId;
  String url;

  Photo({this.photoId, this.url});

  Photo.fromJson(Map<String, dynamic> json) {
    photoId = json['photo_id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo_id'] = this.photoId;
    data['url'] = this.url;
    return data;
  }
}
