class CheckInData {
  int id;
  String reviews;
  var rating;
  String name;
  String reviewDate;
  String reviewAt;
  String isNew;
  CheckInData(
      {this.id,
      this.reviews,
      this.rating,
      this.name,
      this.reviewDate,
      this.reviewAt,
      this.isNew});

  CheckInData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reviews = json['reviews'];
    rating = json['rating'] ?? '0';
    name = json['name'];
    reviewDate = json['review_date'];
    reviewAt = json['review_at'];
    isNew = json['isNew'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reviews'] = this.reviews;
    data['rating'] = this.rating ?? '0';
    data['name'] = this.name;
    data['review_date'] = this.reviewDate;
    data['review_at'] = this.reviewAt;
    data['isNew'] = this.isNew;
    return data;
  }
}
