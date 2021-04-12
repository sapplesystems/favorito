class CarouselData {
  String businessId;
  String photo;

  CarouselData({this.businessId, this.photo});

  CarouselData.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['photo'] = this.photo;
    return data;
  }
}
