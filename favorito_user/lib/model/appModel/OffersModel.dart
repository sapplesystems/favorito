class OfferModel {
  String status;
  String message;
  List<Data> data;

  OfferModel({this.status, this.message, this.data});

  OfferModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
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
  int id;
  String offerTitle;
  String offerDescription;
  String businessName;
  String offerStatus;
  String photo;

  Data(
      {this.id,
      this.offerTitle,
      this.offerDescription,
      this.businessName,
      this.offerStatus,
      this.photo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    offerTitle = json['offer_title'];
    offerDescription = json['offer_description'];
    businessName = json['business_name'];
    offerStatus = json['offer_status'].toString();
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['offer_title'] = this.offerTitle;
    data['offer_description'] = this.offerDescription;
    data['business_name'] = this.businessName;
    data['offer_status'] = this.offerStatus;
    data['photo'] = this.photo;
    return data;
  }
}
