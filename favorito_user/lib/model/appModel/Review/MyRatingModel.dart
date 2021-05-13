class MyRatingModel {
  String status;
  String message;
  List<Data> data;

  MyRatingModel({this.status, this.message, this.data});

  MyRatingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String businessId;
  int rating;

  Data({this.businessId, this.rating});

  Data.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['rating'] = this.rating;
    return data;
  }
}
