class dashModel {
  String status;
  String message;
  dashData data;

  dashModel({this.status, this.message, this.data});

  dashModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new dashData.fromJson(json['data']) : null;
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

class dashData {
  int id;
  String businessId;
  String businessName;
  Null photo;
  String businessStatus;
  int isProfileCompleted;
  int isInformationCompleted;
  int isPhoneVerified;
  int isEmailVerified;
  int isVerified;
  int checkIns;
  double ratings;
  int catalogoues;
  int orders;
  int freeCredit;
  int paidCredit;

  dashData(
      {this.id,
      this.businessId,
      this.businessName,
      this.photo,
      this.businessStatus,
      this.isProfileCompleted,
      this.isInformationCompleted,
      this.isPhoneVerified,
      this.isEmailVerified,
      this.isVerified,
      this.checkIns,
      this.ratings,
      this.catalogoues,
      this.orders,
      this.freeCredit,
      this.paidCredit});

  dashData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    businessName = json['business_name'];
    photo = json['photo'];
    businessStatus = json['business_status'];
    isProfileCompleted = json['is_profile_completed'];
    isInformationCompleted = json['is_information_completed'];
    isPhoneVerified = json['is_phone_verified'];
    isEmailVerified = json['is_email_verified'];
    isVerified = json['is_verified'];
    checkIns = json['check_ins'];
    ratings = json['ratings'];
    catalogoues = json['catalogoues'];
    orders = json['orders'];
    freeCredit = json['free_credit'];
    paidCredit = json['paid_credit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['business_name'] = this.businessName;
    data['photo'] = this.photo;
    data['business_status'] = this.businessStatus;
    data['is_profile_completed'] = this.isProfileCompleted;
    data['is_information_completed'] = this.isInformationCompleted;
    data['is_phone_verified'] = this.isPhoneVerified;
    data['is_email_verified'] = this.isEmailVerified;
    data['is_verified'] = this.isVerified;
    data['check_ins'] = this.checkIns;
    data['ratings'] = this.ratings;
    data['catalogoues'] = this.catalogoues;
    data['orders'] = this.orders;
    data['free_credit'] = this.freeCredit;
    data['paid_credit'] = this.paidCredit;
    return data;
  }
}
