class OfferListDataModel {
  String status;
  String message;
  List<String> offerStatusDropDown;
  List<OfferDataModel> data;

  OfferListDataModel(
      {this.status, this.message, this.offerStatusDropDown, this.data});

  OfferListDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    offerStatusDropDown = json['offer_status_drop_down']?.cast<String>();
    if (json['data'] != null) {
      data = new List<OfferDataModel>();
      json['data'].forEach((v) {
        data.add(new OfferDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['offer_status_drop_down'] = this.offerStatusDropDown;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OfferDataModel {
  int id;
  String offerTitle;
  String offerDescription;
  String offerType;
  String offerStatus;
  int totalActivated;
  int totalRedeemed;

  OfferDataModel(
      {this.id,
      this.offerTitle,
      this.offerDescription,
      this.offerType,
      this.offerStatus,
      this.totalActivated,
      this.totalRedeemed});

  OfferDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    offerTitle = json['offer_title'];
    offerDescription = json['offer_description'];
    offerType = json['offer_type'];
    offerStatus = json['offer_status'];
    totalActivated = json['total_activated'];
    totalRedeemed = json['total_redeemed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['offer_title'] = this.offerTitle;
    data['offer_description'] = this.offerDescription;
    data['offer_type'] = this.offerType;
    data['offer_status'] = this.offerStatus;
    data['total_activated'] = this.totalActivated;
    data['total_redeemed'] = this.totalRedeemed;
    return data;
  }
}
