class CreateOfferRequiredDataModel {
  String status;
  String message;
  CreateOffer data;

  CreateOfferRequiredDataModel({this.status, this.message, this.data});

  CreateOfferRequiredDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new CreateOffer.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class CreateOffer {
  List<String> offerStatusDropDown;
  List<String> offerTypeDropDown;

  CreateOffer({this.offerStatusDropDown, this.offerTypeDropDown});

  CreateOffer.fromJson(Map<String, dynamic> json) {
    offerStatusDropDown = json['offer_status_drop_down']?.cast<String>();
    offerTypeDropDown = json['offer_type_drop_down']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offer_status_drop_down'] = this.offerStatusDropDown;
    data['offer_type_drop_down'] = this.offerTypeDropDown;
    return data;
  }
}
