class NewBusinessData {
  int id;
  String businessId;
  int avgRating;
  int distance;
  String businessName;
  String townCity;
  String photo;
  String businessStatus;

  NewBusinessData(
      {this.id,
      this.businessId,
      this.avgRating,
      this.distance,
      this.businessName,
      this.townCity,
      this.photo,
      this.businessStatus});

  NewBusinessData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    avgRating = json['avg_rating'];
    distance = json['distance'];
    businessName = json['business_name'];
    townCity = json['town_city'];
    photo = json['photo'];
    businessStatus = json['business_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['avg_rating'] = this.avgRating;
    data['distance'] = this.distance;
    data['business_name'] = this.businessName;
    data['town_city'] = this.townCity;
    data['photo'] = this.photo;
    data['business_status'] = this.businessStatus;
    return data;
  }
}
