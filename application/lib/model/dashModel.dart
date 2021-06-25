class DashModel {
  String status;
  String message;
  Data data;

  DashModel({this.status, this.message, this.data});

  DashModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int id;
  String businessId;
  int status;
  String businessName;
  String photo;
  String businessStatus;
  int isProfileCompleted;
  int isInformationCompleted;
  int isPhoneVerified;
  int isEmailVerified;
  int isVerified;
  int checkIns;
  var ratings;
  int ratingCount;
  int catalogoues;
  int orders;
  List<String> businessAttributes;
  var totalSpent;
  var freeCredit;
  var paidCredit;
  var businessType;

  Data(
      {this.id,
      this.businessId,
      this.status,
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
      this.ratingCount,
      this.catalogoues,
      this.orders,
      this.businessAttributes,
      this.totalSpent,
      this.freeCredit,
      this.paidCredit,
      this.businessType});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    status = json['status'];
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
    ratingCount = json['rating_count'];
    catalogoues = json['catalogoues'];
    orders = json['orders'];
    businessAttributes = json['business_keys'].cast<String>();
    totalSpent = json['total_spent'];
    freeCredit = json['free_credit'];
    paidCredit = json['paid_credit'];
    businessType = json['business_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['status'] = this.status;
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
    data['rating_count'] = this.ratingCount;
    data['catalogoues'] = this.catalogoues;
    data['orders'] = this.orders;
    data['business_attributes'] = this.businessAttributes;
    data['total_spent'] = this.totalSpent;
    data['free_credit'] = this.freeCredit;
    data['paid_credit'] = this.paidCredit;
    data['business_type'] = this.businessType;
    return data;
  }
}
